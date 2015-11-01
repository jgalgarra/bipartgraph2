package es.upm.euitt.diatel.redesbipartitas.utils;

import es.upm.euitt.diatel.redesbipartitas.r.REngine;
import es.upm.euitt.diatel.redesbipartitas.r.RException;


/**
*
* Utilidad para resolver la implementacion concreta de la clase Factory
* y poder devolver las implementaciones concretas de las distintias utilidades
*
* @author MAPFRE DCTP - DIAC - Ingeniería
*/
public class FactoryHelper {
    private static Factory INSTANCE;

    /**
     * Constructor privado para evitar instancias
     */
    private FactoryHelper() {
    }

    /**
     * Obtiene la implementacion concreta de la factoria de utilidades
     * @return implementacion de la factoria de utilidades
     */
    private static Factory getInstance() {
        if (INSTANCE==null) {
            synchronized (Factory.class) {
                if (INSTANCE==null) {
                    INSTANCE=new FactoryImpl();
                }
            }
        }

        return INSTANCE;
    }

    /**
     * Obtiene un motor de R
     * @return
     * @throws RException
     */
    public static REngine getREngine() throws RException {
        return getInstance().getREngine();
    }

    /**
     * Obtiene la utilidad de trazas para una clase determinada
     * @param clazz clase para la que obtener el logger
     * @return logger para la generacion de trazas
     */
    public static Logger getLogger(Class<?> clazz) {
        return getInstance().getLogger(clazz);
    }

    /**
     * Obtiene la utilidad de trazas para una clase determinada
     * @param className nombre de la clase para la que obtener el logger
     * @return logger para la generacion de trazas
     */
    public static Logger getLogger(String className) {
        return getInstance().getLogger(className);
    }
}
