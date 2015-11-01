package es.upm.euitt.diatel.redesbipartitas.test;

import java.io.File;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.junit.Assert;
import org.junit.FixMethodOrder;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestName;
import org.junit.runners.MethodSorters;

import es.upm.euitt.diatel.redesbipartitas.r.REngine;
import es.upm.euitt.diatel.redesbipartitas.rest.EntryPoint;
import es.upm.euitt.diatel.redesbipartitas.rest.SVGPoint;
import es.upm.euitt.diatel.redesbipartitas.rest.ShutdownPoint;
import es.upm.euitt.diatel.redesbipartitas.utils.FactoryHelper;
import es.upm.euitt.diatel.redesbipartitas.utils.JettyLogger;
import es.upm.euitt.diatel.redesbipartitas.utils.Logger;

/**
 * Test de generacion de fichero SVG usando R
 * @author JMGARC4
 *
 */
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class TestRB {
    @Rule
    public TestName testName = new TestName();

    // logger
    private final static Logger logger=FactoryHelper.getLogger(TestRB.class);

    /**
     * Test 01 - creacion de grafico con SVG
     */
    @Test
    public void test01SVG() {
        logger.info("Inicio del test '%s'", testName.getMethodName());

        File rSource=new File("testSVG.R");
        logger.info("Comprobando existencia del fichero fuente R '%s'", rSource.getAbsolutePath());
        Assert.assertTrue(rSource.exists());

        // obtiene el motor de R
        try {
            logger.info("Obteniendo motor de R");
            REngine re=FactoryHelper.getREngine();
            logger.info("Esperando la inicializacion de R");
            boolean reWaitFor=re.waitForR();
            Assert.assertTrue(reWaitFor);

            // programilla
            String command="source(\"" + escape(rSource.getAbsolutePath()) + "\", echo=FALSE, encoding=\"UTF-8\")";
            String args="'prueeeba', 'kk'";
            logger.info("Ejecutando comando '%s' [args=%s]", command, args);
            re.eval("commandArgs <- function() c(" + args + ")");
            re.eval(command);
            re.end();
        } catch (Exception e) {
            logger.error(e, "Error en el test '%s': %s", testName.getMethodName(), e.getMessage());
            Assert.assertTrue(false);
        } finally {
            logger.info("Fin del test '%s'", testName.getMethodName());
        }
    }

    /**
     * Test 02 - Servicio HTTP
     */
    @Test
    public void test02HTTPServer() {
        logger.info("Inicio del test '%s'", testName.getMethodName());
        Server server=null;

        try {
            // inicializa el log para Jetty
            org.eclipse.jetty.util.log.Log.setLog(new JettyLogger(org.eclipse.jetty.util.log.Log.class.getCanonicalName()));

            // crea el contexto
            ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
            context.setContextPath("/");

            // crea el servlet
            ServletHolder jerseyServlet = context.addServlet(org.glassfish.jersey.servlet.ServletContainer.class, "/*");
            jerseyServlet.setInitOrder(0);

            // indica a jetty los servicios/clases REST a cargar
            Class<?>        restClasses[]   = {EntryPoint.class, ShutdownPoint.class, SVGPoint.class};
            StringBuilder   restClassNames  = new StringBuilder();
            for (Class<?> restClass:restClasses) {
                restClassNames.append(restClass.getCanonicalName());
                restClassNames.append(";");
            }
            jerseyServlet.setInitParameter("jersey.config.server.provider.classnames", restClassNames.toString());

            // crea el servidor
            server = new Server(8080);
            server.setHandler(context);

            // inicializa el punto de shutdown
            ShutdownPoint.initShutdownPoint(server, context);

            // arranca el servidor
            server.start();
            server.join();
        } catch (Exception e) {
            logger.error(e, "Error en el test '%s': %s", testName.getMethodName(), e.getMessage());
            Assert.assertTrue(false);
        } finally {
            if (server!=null) {
                // cierra el servidor
                server.destroy();
            }
            logger.info("Fin del test '%s'", testName.getMethodName());
        }
    }

    /**
     * Escapa el backslash de una cadena de caracteres
     * @param input
     * @return
     */
    private static String escape(String input) {
        return input.replace("\\", "\\\\");
    }
}
