// actualiza los eventos asociados a los textos del SVG
function updateTextEvents() {
	$("text[id^=text-]").css("cursor", "default");
	$("text[id^=text-]").mouseover(function() {
	    var fontSize=parseInt($("text[id=" + this.id + "]").css("font-size").replace("px",""));
	    $("text[id=" + this.id + "]").css("font-size", (fontSize+4) + "px");
	});
	$("text[id^=text-]").mouseout(function() {
	    var fontSize=parseInt($("text[id=" + this.id + "]").css("font-size").replace("px",""));
	    $("text[id=" + this.id + "]").css("font-size", (fontSize-4) + "px");
	});
}

//actualiza los eventos asociados a los enlaces del SVG
function updatePathEvents() {
	// enlaces curvos
	$("g[id^=bentLink-]").mouseover(function() {
	    var strokeWidth=parseFloat($("g[id=" + this.id + "]").css("stroke-width"));
	    $("g[id=" + this.id + "]").css("stroke-width", strokeWidth+2)
	});
	$("g[id^=bentLink-]").mouseout(function() {
	    var strokeWidth=parseFloat($("g[id=" + this.id + "]").css("stroke-width"));
	    $("g[id=" + this.id + "]").css("stroke-width", strokeWidth-2)
	});
	
	// enlaces rectos
	$("g[id^=straightLink-]").mouseover(function() {
	    var strokeWidth=parseFloat($("g[id=" + this.id + "]").css("stroke-width"));
	    $("g[id=" + this.id + "]").css("stroke-width", strokeWidth+2)
	});
	$("g[id^=straightLink-]").mouseout(function() {
	    var strokeWidth=parseFloat($("g[id=" + this.id + "]").css("stroke-width"));
	    $("g[id=" + this.id + "]").css("stroke-width", strokeWidth-2)
	});
}

// actualiza los eventos asociados a todos los elementos
function updateEvents() {
	updateTextEvents();
	updatePathEvents();
	alert("OKKKK!!")
}

