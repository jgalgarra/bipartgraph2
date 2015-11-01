package es.upm.euitt.diatel.redesbipartitas.rest;

import java.util.Arrays;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;

import es.upm.euitt.diatel.redesbipartitas.utils.FactoryHelper;
import es.upm.euitt.diatel.redesbipartitas.utils.Logger;

@Path("/entry-point")
public class ShutdownPoint {
    private static Server                  server;
    private static ServletContextHandler   context;

    // tiempo de parada del servidor
    private final static long STOP_TIMEOUT=10000L;

    // logger
    private final static Logger logger=FactoryHelper.getLogger(ShutdownPoint.class);

    /**
     * Inicializa servidor y contexto
     * @param server
     * @param context
     */
    public static void initShutdownPoint(Server server, ServletContextHandler context) {
        logger.info("Inicializando punto de shutdown (server.connectors=%s, context.path=%s)", Arrays.asList(server.getConnectors()), context.getContextPath());
        ShutdownPoint.server     = server;
        ShutdownPoint.context    = context;
    }

    /**
     * Realiza la parada del servidor Jetty
     * @return
     * @throws RESTException
     */
    @GET
    @Path("shutdown")
    @Produces(MediaType.TEXT_PLAIN)
    public String shutdown() throws RESTException {
        logger.info("Realizando shutdown del servidor (server.connectors=%s, context.path=%s)", Arrays.asList(server.getConnectors()), context.getContextPath());
        try {
            server.setStopTimeout(STOP_TIMEOUT);
            new Thread() {
                @Override
                public void run() {
                    try {
                        context.stop();
                        server.stop();
                    } catch (Exception ex) {
                        logger.error(ex, "Error parando jetty: %s", ex.getMessage());
                    }
                }
            }.start();
        } catch (Exception e) {
            logger.error(e, "Error parando servidor: %s", e.getMessage());
            throw new RESTException(e);
        }

        return "OK";
    }
}