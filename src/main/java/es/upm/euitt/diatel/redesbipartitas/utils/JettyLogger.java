package es.upm.euitt.diatel.redesbipartitas.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * Logger para jetty
 * @author JMGARC4
 *
 */
public class JettyLogger implements org.eclipse.jetty.util.log.Logger {
    private Logger  logger;
    private String  name;

    /**
     * Logger especifico a partir de nombre de clase
     * @param className nombre de clase
     */
    public JettyLogger(String className) {
        name    = className;
        logger  = FactoryHelper.getLogger(className);
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#debug(java.lang.Throwable)
     */
    @Override
    public void debug(Throwable arg0) {
        logger.debug(arg0, "");
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#debug(java.lang.String, java.lang.Object[])
     */
    @Override
    public void debug(String arg0, Object... arg1) {
        if (logger.isDebugEnabled()) {
            String message=arg0.replace("{}", "%s");
            logger.debug(message, fillArgs(arg1, message));
        }
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#debug(java.lang.String, long)
     */
    @Override
    public void debug(String arg0, long arg1) {
        logger.debug(arg0);
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#debug(java.lang.String, java.lang.Throwable)
     */
    @Override
    public void debug(String arg0, Throwable arg1) {
        logger.debug(arg1, arg0);
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#getLogger(java.lang.String)
     */
    @Override
    public org.eclipse.jetty.util.log.Logger getLogger(String arg0) {
        return new JettyLogger(arg0);
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#getName()
     */
    @Override
    public String getName() {
        return name;
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#ignore(java.lang.Throwable)
     */
    @Override
    public void ignore(Throwable arg0) {
        logger.info(arg0, "");
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#info(java.lang.Throwable)
     */
    @Override
    public void info(Throwable arg0) {
        logger.info(arg0, "");
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#info(java.lang.String, java.lang.Object[])
     */
    @Override
    public void info(String arg0, Object... arg1) {
        if (logger.isInfoEnabled()) {
            String message=arg0.replace("{}", "%s");
            logger.info(message, fillArgs(arg1, message));
        }
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#info(java.lang.String, java.lang.Throwable)
     */
    @Override
    public void info(String arg0, Throwable arg1) {
        logger.info(arg1, arg0);
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#isDebugEnabled()
     */
    @Override
    public boolean isDebugEnabled() {
        return logger.isDebugEnabled();
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#setDebugEnabled(boolean)
     */
    @Override
    public void setDebugEnabled(boolean arg0) {
        // TODO
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#warn(java.lang.Throwable)
     */
    @Override
    public void warn(Throwable arg0) {
        logger.warn(arg0, "");
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#warn(java.lang.String, java.lang.Object[])
     */
    @Override
    public void warn(String arg0, Object... arg1) {
        if (logger.isWarnEnabled()) {
            String message=arg0.replace("{}", "%s");
            logger.warn(message, fillArgs(arg1, message));
        }
    }

    /*
     * (non-Javadoc)
     * @see org.eclipse.jetty.util.log.Logger#warn(java.lang.String, java.lang.Throwable)
     */
    @Override
    public void warn(String arg0, Throwable arg1) {
        logger.warn(arg1, arg0);
    }

    /**
     * Completa la lista de argumentos con cadenas vacias hasta
     * incluir al menos los necesarios para el mensaje
     * @param args argumentos de entrada
     * @param message mensaje a formatear
     * @return
     */
    public static Object[] fillArgs(Object[] args, String message) {
        Pattern p           = Pattern.compile("%s");
        Matcher m           = p.matcher(message);
        int     argCount    = 0;

        // cuenta los argumentos necesarios en el mensaje
        while (m.find()){
            argCount +=1;
        }

        // crea el resultado del tamanyo necesario
        Object  result[]    = new Object[argCount];
        int     argsMax     = args.length<argCount?args.length:argCount;
        for (int i=0;i<argsMax;++i) {
            result[i]=args[i];
        }

        return result;
    }
}
