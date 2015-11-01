package es.upm.euitt.diatel.redesbipartitas.r;

/**
 * Excepcion usada en las interacciones con R
 *
 * @author MAPFRE DCTP - DIAC - Ingeniería
 *
 */
public class RException extends Exception {

    /**
     *
     */
    private static final long serialVersionUID = -7766252783806508898L;

    /**
     *
     */
    public RException() {
        super();
    }

    /**
     *
     * @param message
     */
    public RException(String message) {
        super(message);
    }

    /**
     *
     * @param cause
     */
    public RException(Throwable cause) {
        super(cause);
    }

    /**
     *
     * @param message
     * @param cause
     */
    public RException(String message, Throwable cause) {
        super(message, cause);
    }
}
