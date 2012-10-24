// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress {
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class to store framework global settings and some important variables.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MvcExpress {
	
	/** Home website of mvcExpress. */
	public static const WEBSITE_URL:String = "http://mvcexpress.org";
	
	/** Current framework major version */
	public static const MAJOR_VERSION:uint = 1;
	/** Current framework minor version */
	public static const MINOR_VERSION:uint = 3;
	/** Current framework revision version */
	public static const REVISION:uint = 0;
	
	/** Current framework version */
	public static function get VERSION():String {
		return "v" + MvcExpress.MAJOR_VERSION + "." + MvcExpress.MINOR_VERSION + "." + MvcExpress.REVISION;
	}
	
	/** Gives CONFIG::debug variable value. If it is true framework functions has overhead code, used for debugging and error checking. */
	public static function get DEBUG_COMPILE():Boolean {
		CONFIG::debug {
			return true;
		}
		return false;
	}
	
	/**
	 * Time in ms for framework to wait for missing dependencies.
	 * By default pending dependency feature is disabled, as it is set to 0. If missing injection is encountered - error will be instantly thrown.
	 * If it is > 0, framework will wait this amount of time in milliseconds for missing dependencies to be mapped. (framework will find missing dependencies and resolve them.)
	 * If in this time dependencies will not be resolved - error will be thrown.
	 */
	public static var pendingInjectsTimeOut:int = 0;
	
	/**
	 * Sets a debug function that will get framework activity messages as String's.
	 * By default framework will not send debug data to any function.
	 * ATTENTION : it will work only with compile variable CONFIG:debug set to true.
	 */
	static public var debugFunction:Function = null;
	
	//----------------------------------
	//     Internal
	//----------------------------------
	
	/**
	 * Function to get more detailed framework activity.
	 * @private
	 */
	static pureLegsCore var loggerFunction:Function = null;
	
	/**
	 * Framework function for debugging.
	 * @param	traceObj
	 * @private
	 */
	static pureLegsCore function debug(traceObj:TraceObj):void {
		CONFIG::debug {
			if (debugFunction != null) {
				if (traceObj.canPrint) {
					debugFunction(traceObj);
				}
			}
			use namespace pureLegsCore;
			if (loggerFunction != null) {
				loggerFunction(traceObj);
			}
		}
	}

}
}