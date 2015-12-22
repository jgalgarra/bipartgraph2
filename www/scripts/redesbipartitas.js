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

//actualiza los eventos asociados a todos los elementos del SVG
function updateSVGEvents() {
    // actualiza los eventos asociados a las etiquetas
    var aGuilds=["a", "b"];
    for (var i=0;i<aGuilds.length;++i) {
        for (var j=0;j<10;++j) {
            updateTextEvents("kcore" + j + "-" + aGuilds[i] + "-label", aGuilds[i], j);
        }
    }
    // actualiza los eventos asociados a los enlaces
    updatePathEvents("bentLink");
    updatePathEvents("straightLink");
    
    // inicializa el scroll mediante "drag"
    $("#ziggurat").dragscrollable();
    
    // establece el SVG a su tamaño real
    svgZoomReset();
}

// actualiza los eventos asociados a los textos del SVG
function updateTextEvents(pattern, guild, kcore) {
    // estilo del cursor
    $("text[id*=" + pattern + "]").css("cursor", "pointer");
    
    // eventos
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
    
    // datos asociados al nodo
    $("text[id*=" + pattern + "]").data("main", {"guild":guild, "kcore":kcore});    
}

// actualiza los eventos asociados a los enlaces del SVG
function updatePathEvents(pattern) {
    // estilo del cursor
    $("g[id*=" + pattern + "]").css("cursor", "pointer");
    
    // eventos
    $("g[id*=" + pattern + "]").mouseover(function() {
        var strokeWidth=parseFloat($(this).css("stroke-width"));
        $(this).css("stroke-width", strokeWidth+2)
    });
    $("g[id*=" + pattern + "]").mouseout(function() {
        var strokeWidth=parseFloat($(this).css("stroke-width"));
        $(this).css("stroke-width", strokeWidth-2)
    });
}

// obtiene los identificadores de los elementos en un nodo de texto del SVG
// dividiendo la cadena por los espacios en blanco
function getElements(strElements) {
    var aElements=strElements.split(" ");
    var result=[];
    for (var i=0;i<aElements.length;++i) {
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

// registra la funcion que recorre la tabla en pantalla
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
            for (var i=0;i<deleteFilesList.length;++i) {
                message=message + "  - " + deleteFilesList[i] + "\n"; 
            }
            var bDelete=confirm(message);
            if (bDelete) {
                // envia el evento de borrado al servidor incluyendo la lista de ficheros
                // y un timestamp
                Shiny.onInputChange("deleteFilesData", {timestamp: new Date(), fileList: deleteFilesList});
            }
        }
    }
);

// registra la funcion que se encarga de la visualizacion de la informacion
// de la wikipedia
Shiny.addCustomMessageHandler(
    "wikiDetailsHandler",
    function(elementData) {
        //alert("wikiDetailsHandler: " + JSON.stringify(elementData));
        // modifica el contenido del DIV
        // se apoya en un plugin jQuery que permite esperar a que el elemento exista
        // es necesario porque el message handler y el pintado de la pestaña van en hilos
        // de ejecución distintos
        $("div[id=wikiDetails-" + elementData.id + "]").waitUntilExists(function() {
            // http://en.wikipedia.org/w/api.php?action=query&prop=revisions&format=json&rvprop=content&rvparse=&titles=Bombus%20dahlbomii
            // solo funciona si se usa jquery.getJSON y "callback=?" como parametro
            // si no da error de CORS 'Access-Control-Allow-Origin
            var wikiBase        = "https://en.wikipedia.org";
            var wikiApi         = "/w/api.php";
            var wikiParameters  = {
                 action:        "query",
                 cache:         false,
                 prop:          "revisions",
                 format:        "json",
                 rvprop:        "content",
                 rvparse:       "",
                 titles:        elementData.name
            }
            var wikiUrl         = wikiBase + wikiApi + "?" + $.param(wikiParameters) + "&callback=?";
            //alert("Consultando wikipedia: " + wikiUrl);
            var jqXHR=$.getJSON(wikiUrl);
            jqXHR.done(function(data) {
                //alert("data=" + JSON.stringify(data));
                var pages=data.query.pages;
                for (var property in pages) {
                    // establece el contenido a partir de la primera revision
                    //alert("name=" + property  + ", value=" + pages[property]);
                    var page=pages[property];
                    if (typeof page.revisions=="undefined") {
                        $("div[id=wikiDetails-" + elementData.id + "]").html("No se ha podido encontrar información para " + elementData.name);
                    } else {
                        var revision=page.revisions[0];
                        var content=revision["*"];
                        $("div[id=wikiDetails-" + elementData.id + "]").html(content);
                        
                        // modifica todos los enlaces para que se abran en una nueva ventana
                        // y los relativos para que apunten a wikipedia 
                        $("div[id=wikiDetails-" + elementData.id + "] a").each(function() {
                            var _href=$(this).attr('href');
                            // nueva ventana
                            if (_href.substring(0,1)!="#") {
                                $(this).attr("target", "_blank");

                                // completa los enlaces relativos
                                if (_href.substring(0,1)=="/") {
                                    $(this).attr("href", wikiBase + _href);
                                }
                            }
                        });
                    }
                }
            });
            // no funciona el "fail" con callback, pero lo dejo por si acaso algún día....
            jqXHR.fail(function(jqXHR, textStatus, errorThrown) {
                alert("Error descargando contenido de wikipedia [status=" + textStatus+ ", error=" + errorThrown + "]");
            });
        });
    }
);

// amplia el SVG del ziggurat
function svgZoomIn() {
    var _width  = parseFloat($("#ziggurat svg").css("width").replace("px", ""));
    var _height = parseFloat($("#ziggurat svg").css("height").replace("px", ""));
    $("#ziggurat svg").css({
        "width":    (_width*1.1) + "px",
        "height":   (_height*1.1) + "px"
    });
}

// reduce el SVG del ziggurat
function svgZoomOut() {
    var _width  = parseFloat($("#ziggurat svg").css("width").replace("px", ""));
    var _height = parseFloat($("#ziggurat svg").css("height").replace("px", ""));
    $("#ziggurat svg").css({
        "width":    (_width/1.1) + "px",
        "height":   (_height/1.1) + "px"
    });
}

// ajusta el SVG del ziggurat al marco que lo contiene
function svgZoomFit() {
    var _width  = $("#ziggurat").width();
    var _height = $("#ziggurat").height();
    $("#ziggurat svg").css({
        "width":    (_width/1.1) + "px",
        "height":   (_height/1.1) + "px"
    });
}

// establece el tamaño SVG del ziggurat a su tamaño real
function svgZoomReset() {
    $("#ziggurat svg").each(
        function() {
            var _viewBox    = $(this)[0].getAttribute("viewBox");
            var _width      = _viewBox.split(" ")[2];
            var _height     = _viewBox.split(" ")[3];
            $("#ziggurat svg").css({
                "width":    _width + "px",
                "height":   _height + "px"
            });
        }
    );
}