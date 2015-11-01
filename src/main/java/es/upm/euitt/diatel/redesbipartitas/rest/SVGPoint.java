package es.upm.euitt.diatel.redesbipartitas.rest;

import java.io.File;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import es.upm.euitt.diatel.redesbipartitas.r.REngine;
import es.upm.euitt.diatel.redesbipartitas.utils.FactoryHelper;
import es.upm.euitt.diatel.redesbipartitas.utils.Logger;

@Path("/entry-point")
public class SVGPoint {
    // logger
    private final static Logger logger=FactoryHelper.getLogger(SVGPoint.class);

    /**
     * Metodo para generar SVG
     *
     * @return
     * @throws RESTException
     */
    @GET
    @Path("graph1")
    @Produces(MediaType.APPLICATION_SVG_XML)
    public String graph1(
            @DefaultValue("testSVG.R")  @QueryParam("type")     String type,
            @DefaultValue("10")         @QueryParam("width")    int width,
            @DefaultValue("10")         @QueryParam("height")   int height
    ) throws RESTException {
        logger.info("> graph1(type=%s, width=%s, height=%s)", type, width, height);

        File rSource=new File(type);
        logger.info("Comprobando existencia del fichero fuente R '%s'", rSource.getAbsolutePath());
        if (!rSource.exists()) {
            throw new RESTException("No existe el fichero '" + type + "'");
        }

        // obtiene el motor de R
        try {
            logger.info("Obteniendo motor de R");
            REngine re=FactoryHelper.getREngine();
            logger.info("Esperando la inicializacion de R");
            if (!re.waitForR()) {
                throw new RESTException("No se ha podido inicializar el runtime de R");
            }

            // crea el fichero temporal para la salida
            File tmpFile=File.createTempFile("R-svg-", ".svg");

            // ejecuta el programa en R que crea el SVG
            String command="source(\"" + escape(rSource.getAbsolutePath()) + "\", echo=FALSE, encoding=\"UTF-8\")";
            Object args[]={escape(tmpFile.getAbsolutePath()), new Integer(width), new Integer(height)};
            String commandArgs=commandArgs(args);
            logger.info("Ejecutando comando '%s' [args=%s]", command, commandArgs);
            re.eval("commandArgs <- function() c(" + commandArgs + ")");
            re.eval(command);
            //re.end();
        } catch (Exception e) {
            logger.error(e, "Error en graph1: %s", e.getMessage());
        } finally {

            logger.info("< graph1");
        }

        return "Test";
    }

    /**
     * Escapa el backslash de una cadena de caracteres
     * @param input
     * @return
     */
    private static String escape(String input) {
        return input.replace("\\", "\\\\");
    }

    /**
     * Crea los parametros para llamar a R
     *
     * @param args lista de argumentos para llamar a R
     * @return
     */
    private static String commandArgs(Object args[]) {
        StringBuilder result=new StringBuilder();
        for (Object arg:args) {
            if (arg!=null) {
                if (result.length()>0) {
                    result.append(",");
                }
                result.append("'").append(arg.toString()).append("'");
            }
        }

        return result.toString();
    }
}