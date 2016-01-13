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

// funcion que se llama cuando la pagina esta cargada
function windowLoad() {
    // actualiza los tooltips de ayuda
    updateHelpTooltips();
    
    // indica al servidor que el cliente esta listo
    Shiny.onInputChange("windowLoad", new Date());
}

// establece los tooltips de ayuda de todos los elementos
var helpTooltips=[
    {id: "zoomin",      value: "Incrementar el nivel de zoom del ziggurat"},
    {id: "zoomout",     value: "Disminuir el nivel de zoom del ziggurat"},
    {id: "zoomfit",     value: "Ajustar el ziggurat a la ventana de visualización"},
    {id: "zoomreset",   value: "Visualizar el ziggurat en su tamaño real"}
];
function updateHelpTooltips() {
    for (var i=0;i<helpTooltips.length;++i) {
        $("#" + helpTooltips[i].id).each(function() {
            $(this).qtip({
                content:    {text: helpTooltips[i].value},
                style:      {classes: "qtip-bootstrap rbtooltiphelp"}
            });
        });
    }
}

//actualiza los eventos asociados a todos los elementos del SVG
function updateSVGEvents() {
    // actualiza los eventos asociados a las etiquetas
    for (var i=0;i<zigguratData.ids.length;++i) {
        var guild       = zigguratData.ids[i];
        var guildName   = zigguratData.names[i];
        var guildData   = zigguratData.data[guild];
        updateNodeEvents(guild, guildName, guildData);
    }
    
    // actualiza los eventos asociados a los enlaces
    updateLinkEvents("link");
    
    // inicializa el scroll mediante "drag"
    $("#ziggurat").dragscrollable();
    
    // inicializa el scroll
    $("#ziggurat").perfectScrollbar({scrollXMarginOffset:4, scrollYMarginOffset:4});
    
    // establece el SVG a su tamaño real
    svgZoomReset();
}

// actualiza los eventos asociados a los nodos del SVG
function updateNodeEvents(guild, guildName, guildData) {
    for (var kcore=1;kcore<=guildData.length;++kcore) {
        var pattern="kcore" + kcore + "-" + guild;

        // estilo del cursor
        $("[id*=" + pattern + "]").css("cursor", "pointer");
        
        // eventos para resaltar un nodo informacion de un nodo
        /*
        $("[id*=" + pattern + "]").mouseover(function() {
            markNode($(this).attr("id").replace("-text", "").replace("-rect",""));
        });
        $("[id*=" + pattern + "]").mouseout(function() {
            unmarkNode($(this).attr("id").replace("-text", "").replace("-rect",""));
        });
        */
        // eventos para resaltar un nodo y los asociados
        $("[id*=" + pattern + "]").click(function() {
            markRelatedNodes($(this).attr("id").replace("-text", "").replace("-rect",""));
        });

        // datos asociados al nodo
        $("text[id*=" + pattern + "]").each(function() {
            $(this).data("guild", guild);
            $(this).data("kcore", kcore);
            $(this).data("elements", getElements($(this).find("tspan").toArray()));
            $(this).data("marked", false);
        });
        
        // tooltips
        var guildCoreData=guildData[kcore-1];
        if (guildCoreData!=null) {
            $("text[id*=" + pattern + "]").each(function() {
                var elements=$(this).data("elements");
                var id=$(this).attr("id").replace("-text", "");
                $("[id*=" + id + "]").each(function() {
                    $(this).qtip({
                        content:    {text: getTooltipContent(guildName, kcore, guildCoreData, elements)},
                        style:      {classes: "qtip-bootstrap rbtooltipinfo", width: 500},
                        show:       {delay:50},
                        hide:       {delay:0}
                    });
                });
            });            
        }
    }
}

// actualiza los eventos asociados a los enlaces del SVG
function updateLinkEvents(pattern) {
    // estilo del cursor
    $("g[id*=" + pattern + "]").css("cursor", "pointer");
    
    // eventos
    $("g[id*=" + pattern + "]").mouseover(function() {
        var strokeWidth=parseFloat($(this).css("stroke-width"));
        $(this).css("stroke-width", strokeWidth+2);
    });
    $("g[id*=" + pattern + "]").mouseout(function() {
        var strokeWidth=parseFloat($(this).css("stroke-width"));
        $(this).css("stroke-width", strokeWidth-2);
    });
}

// resalta el nodo indicado en el SVG
function markNode(nodeId) {
    // resalta el borde
    $("rect[id*=" + nodeId + "]").each(function() {
        // incrementa el borde
        var strokeWidth=parseFloat($(this).css("stroke-width"));
        $(this).css("stroke-width", strokeWidth+2);
    });

    // resalta el texto
    $("text[id*=" + nodeId + "]").each(function() {
        // actualiza el estado
        $(this).data("marked", true);
        
        // incrementa la fuente
        var fontSize=parseInt($(this).css("font-size").replace("px",""));
        $(this).css("font-size", (fontSize+4) + "px");
        
        // indica el nodo por el que se ha pasado el raton
        Shiny.onInputChange("nodeData", {
            guild:      $(this).data("guild"), 
            kcore:      $(this).data("kcore"), 
            elements:   $(this).data("elements")
        });
        
        // inicializa el nodo seleccionado
        Shiny.onInputChange("elementData", null);
    });
}

// elimina el resaltado del nodo indicado en el SVG
function unmarkNode(nodeId) {
    // elimina el resaltado del texto
    $("text[id*=" + nodeId + "]").each(function() {
        // decrementa la fuente
        var fontSize=parseInt($(this).css("font-size").replace("px",""));
        $(this).css("font-size", (fontSize-4) + "px");
        
        // actualiza el estado
        $(this).data("marked", false);
    });
    
    // elimina el resaltado del borde
    $("rect[id*=" + nodeId + "]").each(function() {
        // decrementa el borde
        var strokeWidth=parseFloat($(this).css("stroke-width"));
        $(this).css("stroke-width", strokeWidth-2);
    });
}

// resalta el nodo y los relacionados
function markRelatedNodes(nodeId) {
    var elements    = $("text[id*=" + nodeId + "]").data("elements");
    var guild       = $("text[id*=" + nodeId + "]").data("guild");
    var neighbors   = (zigguratData.neighbors[guild])[elements[0]-1];
    if (!$.isArray(neighbors)) {
        neighbors=[neighbors];
    }
    
    // desmarca todos los nodos marcados
    $("text[id*=kcore]").each(function() {
        if ($(this).data("marked")) {
            unmarkNode($(this).attr("id").replace("-text", ""));
        }
    });
    
    // busca los nodos que son vecinos y los marca
    $("text[id*=kcore]").each(function() {
        // si es del guild contrario comprueba si el contenido es alguno de los vecinos
        if ((typeof $(this).data("guild")!="undefined") && $(this).data("guild")!=guild) {
            var i=0;
            var isNeighbor=false;
            var nodeElements=$(this).data("elements");
            while (i<neighbors.length && !isNeighbor) {
                if ($.inArray(neighbors[i], nodeElements)!=-1) {
                    isNeighbor=true;
                }
                ++i;
            }
            
            // si es vecino lo marca
            if (isNeighbor) {
                markNode($(this).attr("id").replace("-text", ""));
            }
        }
    });
}

// obtiene los identificadores de los elementos en un nodo del SVG
function getElements(aElements) {
    var result=[];
    for (var i=0;i<aElements.length;++i) {
        var strElement=aElements[i].innerHTML.trim();
        if (strElement.length>0) {
            var ids=strElement.split(" ");
            for (var j=0;j<ids.length;++j) {
                result.push(parseInt(ids[j]));
            }
        }
    }
    //alert(JSON.stringify(result));
    return result;
}

// obtiene el contenido para un tooltip de informacion de un
// nodo del ziggurat
function getTooltipContent(guildName, kcore, guildCoreData, elements) {
    var content="";
    
    // datos generales
    content+="<table class='rbtooltiptableinfo1'>";
    content+="<tr>";
    content+="<th>" + getMessage("LABEL_ZIGGURAT_INFO_DETAILS_TYPE") + "</th>";
    content+="<td>" + guildName + "</td>";
    content+="</tr>";
    content+="<tr>";
    content+="<th>" + getMessage("LABEL_ZIGGURAT_INFO_DETAILS_KCORE") + "</th>";
    content+="<td>" + kcore + "</td>";
    content+="</tr>";
    content+="</table>";
    
    // datos de cada elemento
    content+="<table class='rbtooltiptableinfo2'>";
    content+="<tr>";
    content+="<th>" + getMessage("LABEL_ZIGGURAT_INFO_DETAILS_ID") + "</th>";
    content+="<th>" + getMessage("LABEL_ZIGGURAT_INFO_DETAILS_NAME") + "</th>";
    content+="<th>" + getMessage("LABEL_ZIGGURAT_INFO_DETAILS_KRADIUS") + "</th>";
    content+="<th>" + getMessage("LABEL_ZIGGURAT_INFO_DETAILS_KDEGREE") + "</th>";
    content+="</tr>";
    for (var i=0;i<elements.length;++i) {
        var id=elements[i];
        var element=getTooltipElementContent(guildCoreData, id);
        content+="<tr>";
        content+="<td>" +  id + "</td>";
        content+="<td>" + element.name + "</td>";
        content+="<td>" + element.kradius + "</td>";
        content+="<td>" + element.kdegree + "</td>";
        content+="</tr>";
    }
    content+="</table>";
    return content;
}

// obtiene los datos concretos asociados a un elemento
// de un nodo del ziggurat
function getTooltipElementContent(guildCoreData, id) {
    var bFound=false;
    var i=0;
    while (!bFound && i<guildCoreData.label.length) {
        if (guildCoreData.label[i]==id) {
            bFound=true;
        } else {
            ++i;
        }
    }
    
    var name="(error)";
    var kdegree="(error)";
    var kradius="(error)";
    if (bFound) {
        name=guildCoreData.name_species[i];
        kdegree=Math.round(guildCoreData.kdegree[i]*100)/100;;
        kradius=Math.round(guildCoreData.kradius[i]*100)/100;;
    }
    value={id:id, name:name, kdegree:kdegree, kradius:kradius};
    return value;
}

// muestra la informacion obtenida de la wikipedia para un elemento concreto
function showWiki(id, name) {
    //alert("showWiki(id=" + id + ", name=" + name + ")");
    Shiny.onInputChange("elementData", {
        id:     id, 
        name:   name
    });
}


//amplia el SVG del ziggurat
function svgZoomIn() {
 var _width  = parseFloat($("#ziggurat svg").css("width").replace("px", ""));
 var _height = parseFloat($("#ziggurat svg").css("height").replace("px", ""));
 $("#ziggurat svg").css({
     "width":    (_width*1.1) + "px",
     "height":   (_height*1.1) + "px"
 });
}

//reduce el SVG del ziggurat
function svgZoomOut() {
 var _width  = parseFloat($("#ziggurat svg").css("width").replace("px", ""));
 var _height = parseFloat($("#ziggurat svg").css("height").replace("px", ""));
 $("#ziggurat svg").css({
     "width":    (_width/1.1) + "px",
     "height":   (_height/1.1) + "px"
 });
}

//ajusta el SVG del ziggurat al marco que lo contiene
function svgZoomFit() {
 var _width  = $("#ziggurat").width();
 var _height = $("#ziggurat").height();
 $("#ziggurat svg").css({
     "width":    (_width) + "px",
     "height":   (_height) + "px"
 });
 
 // restablece el scroll
 $("#ziggurat").scrollTop(0);
 $("#ziggurat").scrollLeft(0);
 $("#ziggurat").perfectScrollbar("update");
}

//establece el tamaño SVG del ziggurat a su tamaño real
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
 
 // restablece el scroll
 $("#ziggurat").scrollTop(0);
 $("#ziggurat").scrollLeft(0);
 $("#ziggurat").perfectScrollbar("update");
}

// registra la funcion que recorre la tabla en pantalla
// y envia el evento al servidor para el borrado de los ficheros
Shiny.addCustomMessageHandler(
    "deleteFilesHandler",
    function(tableId) {
        var deleteFilesList=[];
        $("div[id=" + tableId + "] tbody tr td:nth-child(1)").each(
            function() {
                //alert("this=" + $(this).html());
                deleteFilesList.push($(this).html())
            }
        );
        
        if (deleteFilesList.length>0) {
            var message=getMessage("MESSAGE_CONFIRM_DELETE_FILES") + ":\n";
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
                 cache:         false,
                 format:        "json",
                 action:        "query",
                 prop:          "revisions",
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
                        $("div[id=wikiDetails-" + elementData.id + "]").html(getMessage("MESSAGE_WIKIPEDIA_NO_INFO_ERROR") + " " + elementData.name);
                    } else {
                        var revision=page.revisions[0];
                        var content=revision["*"];
                        $("div[id=wikiDetails-" + elementData.id + "]").html(content);
                        
                        // modifica todos los enlaces para que se abran en una nueva ventana
                        // y los relativos para que apunten a wikipedia 
                        $("div[id=wikiDetails-" + elementData.id + "] a").each(function() {
                            var _href=$(this).attr("href");
                            // nueva ventana
                            if (_href.substring(0,1)!="#") {
                                $(this).attr("target", "_blank");

                                // completa los enlaces relativos
                                if (_href.substring(0,1)=="/") {
                                    $(this).attr("href", wikiBase + _href);
                                }
                            }
                        });
                        
                        // inicializa el scroll
                        $("div[id=wikiDetails-" + elementData.id + "]").perfectScrollbar();
                    }
                }
            });
            // no funciona el "fail" con callback, pero lo dejo por si acaso algún día....
            jqXHR.fail(function(jqXHR, textStatus, errorThrown) {
                alert(getMessage("MESSAGE_WIKIPEDIA_DOWNLOAD_ERROR") + " [status=" + textStatus+ ", error=" + errorThrown + "]");
            });
        });
    }
);

// registra la funcion que se encarga de deshabilitar un div
// de un diagrama mientras se esta generando
Shiny.addCustomMessageHandler(
    "disableDivHandler",
    function(divData) {
        //alert("disableDivHandler(divData=" + JSON.stringify(divData) + ")");
        if (divData.disable) {
            $("#" + divData.id).fadeOut(500);
        } else {
            $("#" + divData.id).fadeIn(500);
        }
    }
);

// registra la funcion que se usa para mostrar los textos de los mensajes 
// en el lenguage seleccionado
var messagesMap=null;
Shiny.addCustomMessageHandler(
    "messagesHandler",
    function(messages) {
        messagesMap=messages;
    }
);
function getMessage(key) {
    return messagesMap[key];
}

//registra la funcion que se usa para mostrar los textos de los mensajes 
//en el lenguage seleccionado
var zigguratData=null;
Shiny.addCustomMessageHandler(
    "zigguratDataHandler",
    function(data) {
        zigguratData=data;
        alert("zigguratData=" + JSON.stringify(zigguratData));
    }
);
