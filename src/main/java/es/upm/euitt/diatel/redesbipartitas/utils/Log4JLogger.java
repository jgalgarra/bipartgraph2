package es.upm.euitt.diatel.redesbipartitas.utils;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.apache.log4j.Level;


/**
 * Adaptador entre el interfaz Logger del CIM y la implementacion de Logger proporcionada por Log4J
 *
 * @author MAPFRE DCTP - DIAC - Ingeniería
 *
 */
public class Log4JLogger implements Logger {
    private org.apache.log4j.Logger logger;

    /**
     * Constructor a partir de clase
     * @param clazz
     */
    public Log4JLogger(Class<?> clazz) {
        logger=org.apache.log4j.Logger.getLogger(clazz);
    }

    /**
     * Constructor a partir de nombre de clase
     * @param className
     */
    public Log4JLogger(String className) {
        logger=org.apache.log4j.Logger.getLogger(className);
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#debug(java.lang.String, java.lang.Object[])
     */
    @Override
    public void debug(String format, Object...args) {
        if (isDebugEnabled()) {
            String message=formatMessage(format, args);
            logger.debug(message);
        }
    }

    /*
     * (non-Javadoc)
     * @see com.mapfre.fwopit.cim.utils.Logger#debug(java.lang.Throwable, java.lang.String, java.lang.Object[])
     */
    @Override
    public void debug(Throwable throwable, String format, Object...args) {
        if (isDebugEnabled()) {
            String message=formatMessage(format, args);
            logger.debug(message, throwable);
        }
    }

    /*
     * (non-Javadoc)
     * @see com.mapfre.fwopit.cim.utils.Logger#isDebugEnabled()
     */
    @Override
    public boolean isDebugEnabled() {
        return Level.DEBUG.isGreaterOrEqual(logger.getEffectiveLevel());
    }

    /*
     * (non-Javadoc)
     * @see com.mapfre.fwopit.cim.utils.Logger#info(java.lang.String, java.lang.Object[])
     */
    @Override
    public void info(String format, Object...args) {
        if (isInfoEnabled()) {
            String message=formatMessage(format, args);
            logger.info(message);
        }
    }

    /*
     * (non-Javadoc)
     * @see com.mapfre.fwopit.cim.utils.Logger#info(java.lang.Throwable, java.lang.String, java.lang.Object[])
     */
    @Override
    public void info(Throwable throwable, String format, Object...args) {
        if (isInfoEnabled()) {
            String message=formatMessage(format, args);
            logger.info(message, throwable);
        }
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#isInfoEnabled()
     */
    @Override
    public boolean isInfoEnabled() {
        return Level.INFO.isGreaterOrEqual(logger.getEffectiveLevel());
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#warn(java.lang.String, java.lang.Object[])
     */
    @Override
    public void warn(String format, Object...args) {
        if (isWarnEnabled()) {
            String message=formatMessage(format, args);
            logger.warn(message);
        }
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#warn(java.lang.Throwable, java.lang.String, java.lang.Object[])
     */
    @Override
    public void warn(Throwable throwable, String format, Object...args) {
        if (isWarnEnabled()) {
            String message=formatMessage(format, args);
            logger.warn(message, throwable);
        }
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#isWarnEnabled()
     */
    @Override
    public boolean isWarnEnabled() {
        return Level.WARN.isGreaterOrEqual(logger.getEffectiveLevel());
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#error(java.lang.String, java.lang.Object[])
     */
    @Override
    public void error(String format, Object...args) {
        if (isErrorEnabled()) {
            String message=formatMessage(format, args);
            logger.error(message);
        }
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#error(java.lang.Throwable, java.lang.String, java.lang.Object[])
     */
    @Override
    public void error(Throwable throwable, String format, Object...args) {
        if (isErrorEnabled()) {
            String message=formatMessage(format, args);
            logger.error(message, throwable);
        }
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#isErrorEnabled()
     */
    @Override
    public boolean isErrorEnabled() {
        return Level.ERROR.isGreaterOrEqual(logger.getEffectiveLevel());
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#fatalError(java.lang.String, java.lang.Object[])
     */
    @Override
    public void fatalError(String format, Object...args) {
        if (isFatalErrorEnabled()) {
            String message=formatMessage(format, args);
            logger.fatal(message);
        }
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#fatalError(java.lang.Throwable, java.lang.String, java.lang.Object[])
     */
    @Override
    public void fatalError(Throwable throwable, String format, Object...args) {
        if (isFatalErrorEnabled()) {
            String message=formatMessage(format, args);
            logger.fatal(message, throwable);
        }
    }

    /*
     * (non-Javadoc)
     * @see es.upm.euitt.diatel.redesbipartitas.utils.Logger#isFatalErrorEnabled()
     */
    @Override
    public boolean isFatalErrorEnabled() {
        return Level.FATAL.isGreaterOrEqual(logger.getEffectiveLevel());
    }

    /**
     * Formatea una cadena incluyendo los argumentos indicados
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     * @return
     */
    private static String formatMessage(String format, Object...args) {
        StringWriter    s = new StringWriter();
        PrintWriter     p = new PrintWriter(s);

        p.printf(format, args);
        return s.toString();
    }
}
