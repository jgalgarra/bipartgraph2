package es.upm.euitt.diatel.redesbipartitas.r;

import org.rosuda.JRI.Rengine;

/**
 * Implementacion del motor de R
 * @author JMGARC4
 *
 */
public class REngine extends Rengine {
    /**
     * Obtiene el motor de R
     * @return
     * @throws RException
     */
    public static REngine getREngine() throws RException {
        String[] RArgs = { "--vanilla" };
        return new REngine(RArgs);
    }

    /**
     * Constructor
     * @param RArgs
     */
    private REngine(String[] RArgs) {
        super(RArgs, false, new CallbackListener());
    }
}
