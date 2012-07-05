package org.mvcexpress {

/**
 * Class to store framework global settings and some important variables.
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MvcExpress {
	
	public static const WEBSITE_URL:String = "http://mvcexpress.org";
	public static const VERSION:int = 1.0;
	
	/**
	 * Time in ms for framework to wait for missing dependencies.
	 * By default ending dependency feature is disabled, as it is set to 0. If missing injection is encauntered - error will be instantly thrown.
	 * If it is > 0, framework will wait this amount of time in milliseconds for mising dependencies to be maped. (framework will find missing dependencies and resolve them.)
	 * If in this time dependencies will not be resolved - error will be thrown.
	 */
	public static var pendingInjectsTimeOut:int = 0;
	
	
	
	
	/**
	 * Sets a debug function that will get framework activity messages as String's.
	 * By default framework will not send debug data to any function.
	 * ATTENTION : it will work only with compile variable CONFIG:debug set to true.
	 */
	static public var debugFunction:Function = null;

	
}
}