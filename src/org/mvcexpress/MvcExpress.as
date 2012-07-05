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
	 * If in this time dependencies will not be resolved - error will be thrown.
	 * Seting it to 0 will disable the feature. If missing injection is encauntered - error will be instantly thrown.
	 */
	public static var pendingInjectsTimeOut:int = 0;

}
}