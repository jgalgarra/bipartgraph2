package es.upm.euitt.diatel.redesbipartitas.utils;

/**
 *
 * Abstraccion de Logger para poder usar diferentes implementaciones de traza
 *
 * @author MAPFRE DCTP - DIAC - Ingeniería
 */
public interface Logger {
    /**
     * Traza de depuracion
     *
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void debug(String format, Object...args);

    /**
     * Traza de depuracion
     *
     * @param throwable
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void debug(Throwable throwable, String format, Object...args);

    /**
     * Obtiene si el nivel de traza es de depuracion
     *
     * @return true si el nivel de traza es depuracion, false en caso contrario
     */
    public boolean isDebugEnabled();

    /**
     * Traza de informacion
     *
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void info(String format, Object...args);

    /**
     * Traza de informacion
     *
     * @param throwable
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void info(Throwable throwable, String format, Object...args);

    /**
     * Obtiene si el nivel de traza es informacion
     *
     * @return true si el nivel de traza es informacion, false en caso contrario
     */
    public boolean isInfoEnabled();

    /**
     * Traza de aviso
     *
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void warn(String format, Object...args);

    /**
     * Traza de aviso
     *
     * @param throwable
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void warn(Throwable throwable, String format, Object...args);

    /**
     * Obtiene si el nivel de traza es aviso
     *
     * @return true si el nivel de traza es aviso, false en caso contrario
     */
    public boolean isWarnEnabled();

    /**
     * Traza de error
     *
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void error(String format, Object...args);

    /**
     * Traza de error
     *
     * @param throwable
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void error(Throwable throwable, String format, Object...args);

    /**
     * Obtiene si el nivel de traza es error
     *
     * @return true si el nivel de traza es error, false en caso contrario
     */
    public boolean isErrorEnabled();

    /**
     * Traza de error fatal
     *
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void fatalError(String format, Object...args);

    /**
     * Traza de error fatal
     *
     * @param throwable
     * @param format cadena de formateo tal y como se describe en java.util.Formatter
     * @param args argumentos referenciados en la cadena de formateo
     */
    public void fatalError(Throwable throwable, String format, Object...args);

    /**
     * Obtiene si el nivel de traza es error fatal
     *
     * @return true si el nivel de traza es error fatal, false en caso contrario
     */
    public boolean isFatalErrorEnabled();
}
