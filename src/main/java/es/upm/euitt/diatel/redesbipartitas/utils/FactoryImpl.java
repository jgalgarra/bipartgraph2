package es.upm.euitt.diatel.redesbipartitas.utils;

import es.upm.euitt.diatel.redesbipartitas.r.REngine;
import es.upm.euitt.diatel.redesbipartitas.r.RException;


/**
 * Implementacion de la factoria de utilidades
 *
 * @author MAPFRE DCTP - DIAC - Ingeniería
 */
public final class FactoryImpl implements Factory {
    private boolean jriLoaded=false;
    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Factory#getREngine()
     */
    @Override
    public REngine getREngine() throws RException {
        try {
            // trata de cargar la libreria JRI, para adelantar el error
            if (!jriLoaded) {
                System.loadLibrary("jri");
                jriLoaded=true;
            }
            return REngine.getREngine();
        } catch (UnsatisfiedLinkError e) {
            throw new RException("No se ha podido inicializar el runtime de R: " + e.getMessage(), e);
        }
    }

    /*
     * (non-Javadoc)
     * @see com.mapfre.fwopit.cim.interfaces.Factory#getLogger(java.lang.Class)
     */
    @Override
    public Logger getLogger(Class<?> clazz) {
        return new Log4JLogger(clazz);
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Factory#getLogger(java.lang.String)
     */
    @Override
    public Logger getLogger(String className) {
        return new Log4JLogger(className);
    }
}