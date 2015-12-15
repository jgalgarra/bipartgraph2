// actualiza los eventos asociados a los textos del SVG
function updateTextEvents(pattern, guild, kcore) {
	$("text[id*=" + pattern + "]").css("cursor", "default");
	$("text[id*=" + pattern + "]").data("main", {"guild":guild, "kcore":kcore});
	$("text[id*=" + pattern + "]").mouseover(function() {
	    var fontSize=parseInt($(this).css("font-size").replace("px",""));
	    $(this).css("font-size", (fontSize+4) + "px");
	    
	    // indica el nodo por el que se ha pasado el raton
	    Shiny.onInputChange("nodeData", {
	    	guild: 		$(this).data("main").guild, 
	    	kcore: 		$(this).data("main").kcore, 
	    	species:	getSpecies($(this).html())
	    });
	    
	    // inicializa el nodo seleccionado
	    Shiny.onInputChange("speciesData", null);
	});
	$("text[id*=" + pattern + "]").mouseout(function() {
	    var fontSize=parseInt($(this).css("font-size").replace("px",""));
	    $(this).css("font-size", (fontSize-4) + "px");
	});
}

//actualiza los eventos asociados a los enlaces del SVG
function updatePathEvents(pattern) {
	$("g[id*=" + pattern + "]").mouseover(function() {
	    var strokeWidth=parseFloat($(this).css("stroke-width"));
	    $(this).css("stroke-width", strokeWidth+2)
	});
	$("g[id*=" + pattern + "]").mouseout(function() {
	    var strokeWidth=parseFloat($(this).css("stroke-width"));
	    $(this).css("stroke-width", strokeWidth-2)
	});
}

// actualiza los eventos asociados a todos los elementos
function updateEvents() {
	var aGuilds=["a", "b"];
	var i,j;
	for (i=0;i<aGuilds.length;++i) {
		for (j=0;j<10;++j) {
			updateTextEvents("kcore" + j + "-" + aGuilds[i] + "-label", aGuilds[i], j);
		}
	}
	updatePathEvents("bentLink");
	updatePathEvents("straightLink");
}

// obtiene los identificadores de las especies en un nodo de texto del SVG
// dividiendo la cadena por los espacios en blanco
function getSpecies(strSpecies) {
	var aSpecies=strSpecies.split(" ");
	var i,j=0,result=[];
	for (i=0;i<aSpecies.length;++i) {
		var strSpecies=aSpecies[i].trim();
		if (strSpecies.length>0) {
			result.push({id:strSpecies});
		}
	}
	return result;
}

// muestra la informacion obtenida de la wikipedia para una especie
function showWiki(id, name) {
	//alert("showWiki(id=" + id + ", name=" + name + ")");
	Shiny.onInputChange("speciesData", {
    	id:		id, 
    	name: 	name
    });
}