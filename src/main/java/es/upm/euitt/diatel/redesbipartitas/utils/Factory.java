package es.upm.euitt.diatel.redesbipartitas.utils;

import es.upm.euitt.diatel.redesbipartitas.r.REngine;
import es.upm.euitt.diatel.redesbipartitas.r.RException;



/**
 *
 * Factoria para la creación de utilidades, concretamente las implementaciones
 * a utilizar de los distintos interfaces (Logger, ...)
 *
 * @author MAPFRE DCTP - DIAC - Ingeniería
 */
public abstract interface Factory {
    /**
     * Obtiene el motor de ejecucion de R
     * @return
     * @throws RException
     */
    public abstract REngine getREngine() throws RException;

    /**
     * Obtiene la utilidad de trazas para una clase concreta
     * @param clazz clase para la que obtener el logger
     * @return logger para la generacion de trazas
     */
    public abstract Logger getLogger(Class <?> clazz);

    /**
     * Obtiene la utilidad de trazas para una clase concreta
     * @param className nombre de la clase para la que obtener el logger
     * @return logger para la generacion de trazas
     */
    public abstract Logger getLogger(String className);
}