//-----------------------------------------------------------------------------
// Universidad Politécnica de Madrid - EUITT
//  PFC
//  Representación gráfica de redes bipartitas basadas en descomposición k-core 
// 
// Autor         : Juan Manuel García Santi
// Módulo        : redesbipartitas.js
// Descricpción  : Funciones javascript que permiten la interacción del usuario
//                 con el diagrama ziggurat y la presentación de la información
//                 relativa a nodos y elementos
//-----------------------------------------------------------------------------

// actualiza los eventos asociados a los textos del SVG
function updateTextEvents(pattern, guild, kcore) {
    $("text[id*=" + pattern + "]").css("cursor", "default");
    $("text[id*=" + pattern + "]").data("main", {"guild":guild, "kcore":kcore});
    $("text[id*=" + pattern + "]").mouseover(function() {
        var fontSize=parseInt($(this).css("font-size").replace("px",""));
        $(this).css("font-size", (fontSize+4) + "px");
        
        // indica el nodo por el que se ha pasado el raton
        Shiny.onInputChange("nodeData", {
            guild:      $(this).data("main").guild, 
            kcore:      $(this).data("main").kcore, 
            elements:   getElements($(this).html())
        });
        
        // inicializa el nodo seleccionado
        Shiny.onInputChange("elementsData", null);
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

// obtiene los identificadores de los elementos en un nodo de texto del SVG
// dividiendo la cadena por los espacios en blanco
function getElements(strElements) {
    var aElements=strElements.split(" ");
    var i,result=[];
    for (i=0;i<aElements.length;++i) {
        var strElement=aElements[i].trim();
        if (strElement.length>0) {
            result.push({id:strElement});
        }
    }
    //alert(JSON.stringify(result));
    return result;
}

// muestra la informacion obtenida de la wikipedia para un elemento concreto
function showWiki(id, name) {
    //alert("showWiki(id=" + id + ", name=" + name + ")");
    Shiny.onInputChange("elementData", {
        id:     id, 
        name:   name
    });
}

//registra la funcion que recorre la tabla en pantalla
// y envia el evento al servidor para el borrado de los ficheros
var deleteFilesList=[];
Shiny.addCustomMessageHandler(
    "deleteFilesHandler",
    function(tableId) {
        deleteFilesList=[];
        $("div[id=" + tableId + "] tbody tr td:nth-child(1)").each(
            function() {
                //alert("this=" + $(this).html());
                deleteFilesList.push($(this).html())
            }
        );
        
        if (deleteFilesList.length>0) {
            var message="¿Desea borrar los ficheros siguientes?:\n";
            var i;
            for (i=0;i<deleteFilesList.length;++i) {
                message=message + "  - " + deleteFilesList[i] + "\n"; 
            }
            var bDelete=confirm(message);
            if (bDelete) {
                // envia el evento de borrado al servidor incluyendo la lista de ficheros
                // y un timestamp
                Shiny.onInputChange("deleteFilesData", {timestamp: new Date, fileList: deleteFilesList});
            }
        }
    }
);
