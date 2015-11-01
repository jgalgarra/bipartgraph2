require("ggplot2")
#
args <- commandArgs()
print(paste("---- Argumentos de entrada: (", length(args), ")"))
for (i in 1:length(args)) {
    print(paste("----   ", i, ": ", args[i]))    
}
stop("Oooooh")
#some sample data
head(diamonds) 
#to see actually what will be plotted and compare 
qplot(clarity, data=diamonds, fill=cut, geom="bar")
#save the plot in a variable image to be able to export to svg
image=qplot(clarity, data=diamonds, fill=cut, geom="bar")
#This actually save the plot in a image
ggsave(file="C:\\temp\\test.svg", plot=image, width=10, height=6)
print("---- FIN")