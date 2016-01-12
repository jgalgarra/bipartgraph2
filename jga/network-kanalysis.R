library(igraph)
library(bipartite)

read_network <- function(namenetwork, guild_astr = "pl", guild_bstr = "pol", directory="")
  # Reads a network interaction matrix from a CSV file
  #
  # Args:
  #   namenetwork: CSV file that contains the interaction matrix
  #   guild_a, guild_b: Identifier of the guild of speciea of each class. Default "pl" (plant)
  #                     "pol" (pollinator)
  #   directory: directory where newtork CSVs are located
  #
  # Return List:
  #   graph: Newtork as an igraph object
  #   m    : Interaction matrix
  #   num_guild_b : number of species of guild_b
  #   num_guild_a" : number of species of guild_a
  #   names_guild_a : names of nodes of guild_a
  #   names_guild_b : names of species of guild_b
{
  # Reading species names
  namesred <- read.csv(paste0(directory,namenetwork),header=FALSE,stringsAsFactors=FALSE)
  names_guild_a <- namesred[1,2:ncol(namesred)]
  names_guild_b <- namesred[2:nrow(namesred),1]

  #Reading matrix data
  m <- read.csv(paste0(directory,namenetwork),header=TRUE,row.names=1)

  num_guild_a <- ncol(m)
  num_guild_b <- nrow(m)
  g <- graph.empty()
  for (i in 1:num_guild_a){
    g <- g + vertices(paste0(guild_astr,i),color="white",guild_id="a",id=i)
    }
  for (i in 1:num_guild_b){
    g <- g + vertices(paste0(guild_bstr,i),color="red",guild_id="b",id=i)
    }
  for (i in 1:num_guild_b){
    for (j in 1:num_guild_a){
      if (m[i,j]!=0) {
        g <- g + edges(paste0(guild_bstr,i),paste0(guild_astr,j))
      }
    }
  }
  calc_values <- list("graph" = g, "matrix" = m, "num_guild_b" = num_guild_b, "num_guild_a" = num_guild_a,
                      "names_guild_a" = names_guild_a, "names_guild_b"=names_guild_b)
  return(calc_values)
}

randomize_and_write <- function(matrix, namenetwork, rlinks = 0,  directory = "", bypercentage = TRUE)
{
    if (bypercentage)
      filesuf <- paste0("_rnd_",rlinks)
    else
      filesuf <- paste0("_lnk_",rlinks)
    if (rlinks > 0)
    {
      links <- matrix == 1
      nolinks <- matrix == 0
      rows <- nrow(matrix)
      cols <- ncol(matrix)
      if (bypercentage)
        extractions <- round(rlinks*sum(links)/100)
      else
        extractions <- rlinks
      onestozeroes <- sample(which(links),extractions)
      zeroestoones <- sample(which(nolinks),extractions)
      for (i in onestozeroes){
        matrix[i] = 0
      }
      for (i in zeroestoones){
        matrix[i] = 1
      }
    }
    nfile <- paste0(directory,strsplit(namenetwork,"\\.")[[1]][1],filesuf,".csv")
    write.csv(matrix,nfile)
}

analyze_network <- function(namenetwork, directory="", guild_a = "pl", guild_b = "pol", plot_graphs = FALSE)
{
    nread <- read_network(namenetwork, directory = directory, guild_astr = guild_a, guild_bstr = guild_b)
    g <- as.undirected(nread$g)
    m <- nread$matrix
    names_guild_a <- nread$names_guild_a
    names_guild_b <- nread$names_guild_b
    num_guild_b <- nread$num_guild_b
    num_guild_a <- nread$num_guild_a
    edge_matrix <- get.edges(g, E(g))
    spaths_mat <- shortest.paths(g)
    g_cores <- graph.coreness(g)

    wtc <- walktrap.community(g)
    #modularity(wtc)
    modularity_measure <- modularity(g, membership(wtc))


    if (plot_graphs){
      plot(g, vertex.size=8, layout=layout.kamada.kawai)
      hist(g_cores,right=FALSE)
    }
    lcores <- unique(g_cores)
    max_core <- max(lcores)
    min_core <- min(lcores)
    p <- rep(NA, length(lcores))
    for (k in lcores)
    {
      p[k] <- list(names(g_cores[g_cores == k]))
    }
    # Find plants and plos of a core

    plants_k <- list(rep(NA,max_core))
    pols_k <- list(rep(NA,max_core))
    for (i in 1:max_core)
    {
      auxincore <- c(p[[i]][grep(guild_a,as.character(unlist(p[i])))])
      if (length(auxincore)>0){
        plants_k[[i]] <- auxincore
      }
      else{
        plants_k[[i]] <- c(NA)
      }
      auxincore <- c(p[[i]][grep(guild_b,as.character(unlist(p[i])))])
      if (length(auxincore)>0){
        pols_k[[i]] <- auxincore
      }
      else{
        pols_k[[i]] <- c(NA)
      }
    }
    plants_maxcore <- p[[max_core]][grep(guild_a,as.character(unlist(p[max_core])))]
    pols_maxcore <- p[[max_core]][grep(guild_b,as.character(unlist(p[max_core])))]
    # Purge possible nodes of kcore number maximum that are not part of the giant component
    # Only one case detected, when kcoremax == 2, network PL_30

    if (max_core ==2)
    {
      meandiscnodes <- mean(spaths_mat== Inf)
      for (i in plants_maxcore)
        if (mean(spaths_mat[i,] == Inf)>2*meandiscnodes)
          plants_maxcore <- plants_maxcore[plants_maxcore!=i]
      for (i in pols_maxcore)
        if (mean(spaths_mat[i,] == Inf)>2*meandiscnodes)
          pols_maxcore <- pols_maxcore[pols_maxcore!=i]
    }
    V(g)$kradius <- NA
    V(g)$kcorenum <- NA
    V(g)$kdegree <- 0
    V(g)$guild <- ""
    E(g)$weights <- 1
    for (i in 1:max_core)
    {
      lnod <- p[[i]]
      if (sum(!is.na(lnod))>0){
        for (k in lnod)
          V(g)[k]$kcorenum <- i
      }
    }

    for (i in 1:num_guild_b){
      namepol <- paste0(guild_b,i)
      kradius <- 0
      kradius_core <- mean(spaths_mat[namepol,][plants_maxcore])
      if (!is.na(kradius_core)){
        kradius <- kradius + kradius_core
      }
      V(g)[namepol]$kradius <- kradius
      V(g)[namepol]$guild <- guild_b
      V(g)[namepol]$name_species <- unlist(names_guild_b[i])
      }
    for (i in 1:num_guild_a){
      nameplant <- paste0(guild_a,i)
      kradius <- 0
      kradius_core <- mean(spaths_mat[nameplant,][pols_maxcore])
      if (!is.na(kradius_core)){
          kradius <- kradius + kradius_core
      }
      V(g)[nameplant]$kradius <- kradius
      V(g)[nameplant]$guild <- guild_a
      V(g)[nameplant]$name_species <- unlist(names_guild_a[i])
    }
    meandist <- mean(V(g)$kradius[V(g)$kradius != Inf])
    nested_values<- nested(as.matrix(m), "ALL")

    # kdegree computation

    for (l in 1:nrow(edge_matrix))
    {
      polvertex = edge_matrix[l,1]
      plantvertex = edge_matrix[l,2]
      V(g)[polvertex]$kdegree = V(g)[polvertex]$kdegree + 1/V(g)[plantvertex]$kradius
      V(g)[plantvertex]$kdegree = V(g)[plantvertex]$kdegree + 1/V(g)[polvertex]$kradius
    }
    meankdegree <- mean(V(g)$kdegree)


    calc_values <- list("graph" = g, "max_core" = max_core, "nested_values" = nested_values, "num_guild_a" = num_guild_a,
                        "num_guild_b" = num_guild_b, "links" = length(V(g)), "meandist" = meandist, "meankdegree" = meankdegree,
                        "spaths_mat" = spaths_mat, "matrix" = as.matrix(m), "g_cores" = g_cores, "modularity_measure" = modularity_measure)
    return(calc_values)
}

get_bipartite <- function(g, str_guild_a = "Plant", str_guild_b = "Pollinator", plot_graphs = FALSE)
{
  bg <- g
  V(bg)$type <- FALSE
  V(bg)$label <- ""
  for (i in V(bg)$name)
    if (length(grep(str_guild_b,i))>0){
      V(bg)[which(V(bg)$name==i)]$type <- TRUE
      V(bg)[which(V(bg)$name==i)]$label <- strsplit(i,str_guild_b)[[1]][2]
    }
    else
      V(bg)[which(V(bg)$name==i)]$label <- strsplit(i,str_guild_a)[[1]][2]
  V(bg)$name <- V(bg)$label
  return(bg)
}

#result_analysis <- analyze_network("M_PL_030.csv", directory = "data/", guild_a = "Plant", guild_b = "Pollinator", plot_graphs = TRUE)