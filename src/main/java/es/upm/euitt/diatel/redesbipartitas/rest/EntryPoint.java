package es.upm.euitt.diatel.redesbipartitas.rest;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import es.upm.euitt.diatel.redesbipartitas.utils.FactoryHelper;
import es.upm.euitt.diatel.redesbipartitas.utils.Logger;

@Path("/entry-point")
public class EntryPoint {
    // logger
    private final static Logger logger=FactoryHelper.getLogger(ShutdownPoint.class);

    /**
     * Metodo de test
     * @return
     */
    @GET
    @Path("test")
    @Produces(MediaType.TEXT_PLAIN)
    public String test() {
        logger.info("test");
        return "Test";
    }
}