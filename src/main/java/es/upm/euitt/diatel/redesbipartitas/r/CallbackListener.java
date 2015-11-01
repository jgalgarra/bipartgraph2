package es.upm.euitt.diatel.redesbipartitas.r;

import org.rosuda.JRI.RMainLoopCallbacks;
import org.rosuda.JRI.Rengine;

import es.upm.euitt.diatel.redesbipartitas.utils.FactoryHelper;
import es.upm.euitt.diatel.redesbipartitas.utils.Logger;

/**
 * Implementacion de la clase que recibe los "callback" del runtime de R
 *
 * @author Juan Manuel García Santi
 */
public class CallbackListener implements RMainLoopCallbacks {

    // logger
    private final static Logger logger=FactoryHelper.getLogger(CallbackListener.class);

    /*
     * (non-Javadoc)
     * @see org.rosuda.JRI.RMainLoopCallbacks#rBusy(org.rosuda.JRI.Rengine, int)
     */
    @Override
    public void rBusy(Rengine arg0, int arg1) {
        logger.debug("rBusy(Rengine=%s, arg1=%d)", arg0, arg1);
    }

    /*
     * (non-Javadoc)
     * @see org.rosuda.JRI.RMainLoopCallbacks#rChooseFile(org.rosuda.JRI.Rengine, int)
     */
    @Override
    public String rChooseFile(Rengine arg0, int arg1) {
        logger.debug("rChooseFile(Rengine=%s, arg1=%d)", arg0, arg1);
        return null;
    }

    /*
     * (non-Javadoc)
     * @see org.rosuda.JRI.RMainLoopCallbacks#rFlushConsole(org.rosuda.JRI.Rengine)
     */
    @Override
    public void rFlushConsole(Rengine arg0) {
        logger.debug("rFlushConsole(Rengine=%s)", arg0);
    }

    /*
     * (non-Javadoc)
     * @see org.rosuda.JRI.RMainLoopCallbacks#rLoadHistory(org.rosuda.JRI.Rengine, java.lang.String)
     */
    @Override
    public void rLoadHistory(Rengine arg0, String arg1) {
        logger.debug("rLoadHistory(Rengine=%s, arg1=%s)", arg0, arg1);
    }

    /*
     * (non-Javadoc)
     * @see org.rosuda.JRI.RMainLoopCallbacks#rReadConsole(org.rosuda.JRI.Rengine, java.lang.String, int)
     */
    @Override
    public String rReadConsole(Rengine arg0, String arg1, int arg2) {
        logger.debug("rReadConsole(Rengine=%s, arg1=%s, arg2=%d)", arg0, arg1, arg2);
        return null;
    }

    /*
     * (non-Javadoc)
     * @see org.rosuda.JRI.RMainLoopCallbacks#rSaveHistory(org.rosuda.JRI.Rengine, java.lang.String)
     */
    @Override
    public void rSaveHistory(Rengine arg0, String arg1) {
        logger.debug("rSaveHistory(Rengine=%s, arg1=%s)", arg0, arg1);
    }

    /*
     * (non-Javadoc)
     * @see org.rosuda.JRI.RMainLoopCallbacks#rShowMessage(org.rosuda.JRI.Rengine, java.lang.String)
     */
    @Override
    public void rShowMessage(Rengine arg0, String arg1) {
        logger.debug("rShowMessage(Rengine=%s, arg1=%s)", arg0, arg1);
    }

    /*
     * (non-Javadoc)
     * @see org.rosuda.JRI.RMainLoopCallbacks#rWriteConsole(org.rosuda.JRI.Rengine, java.lang.String, int)
     */
    @Override
    public void rWriteConsole(Rengine arg0, String arg1, int arg2) {
        logger.debug("rWriteConsole(Rengine=%s, arg1=%s, arg2=%d)", arg0, arg1, arg2);
        System.out.print(arg1);
    }
}
