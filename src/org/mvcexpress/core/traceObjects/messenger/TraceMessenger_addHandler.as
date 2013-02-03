// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.messenger {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceMessenger_addHandler extends TraceObj {
	
	public var type:String;
	public var handler:Function;
	public var handlerClassName:String;
	
	public function TraceMessenger_addHandler(moduleName:String, $type:String, $handler:Function, $handlerClassName:String) {
		super(MvcTraceActions.MESSENGER_ADDHANDLER, moduleName);
		type = $type;
		handler = $handler;
		handlerClassName = $handlerClassName;
	}
	
	override public function toString():String {
		return "••<+ " + MvcTraceActions.MESSENGER_ADDHANDLER + " > type : " + type + ", handlerClassName : " + handlerClassName + "     {" + moduleName + "}";
	}
}
}