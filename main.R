###############################################################################
# Universidad Politécnica de Madrid - EUITT
#   PFC
#   Representación gráfica de redes bipartitas basadas en descomposición k-core 
# 
# Autor         : Juan Manuel García Santi
# Módulo        : main.R
# Descricpción  : Ejecución de la aplicación
###############################################################################
library(shiny)
runApp(
  appDir        = ".",
  port          = 8080,
  host          = "192.168.1.104",
  display.mode  = "normal"
)

testPDF<-function() {
  for (sc in c(1,2,4)) {
    pdf(width=100*sc*0.0393701,height=200*sc*0.0393701,pointsize=12,file=paste("scale",sc,".pdf",sep=""))
    plot(sin((1:314)/100),main=paste("PDF sc",sc))
    dev.off()  
  }
}