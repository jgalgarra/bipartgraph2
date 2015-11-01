package es.upm.euitt.diatel.redesbipartitas.rest;

/**
 * Excepcion usada en las interacciones con R
 *
 * @author MAPFRE DCTP - DIAC - Ingeniería
 *
 */
public class RESTException extends Exception {

    /**
     *
     */
    private static final long serialVersionUID = -7766252783806508898L;

    /**
     *
     */
    public RESTException() {
        super();
    }

    /**
     *
     * @param message
     */
    public RESTException(String message) {
        super(message);
    }

    /**
     *
     * @param cause
     */
    public RESTException(Throwable cause) {
        super(cause);
    }

    /**
     *
     * @param message
     * @param cause
     */
    public RESTException(String message, Throwable cause) {
        super(message, cause);
    }
}
