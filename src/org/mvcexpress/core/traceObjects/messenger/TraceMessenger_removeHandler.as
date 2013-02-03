// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.messenger {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceMessenger_removeHandler extends TraceObj {
	
	public var type:String;
	public var handler:Function;
	
	public function TraceMessenger_removeHandler(moduleName:String, $type:String, $handler:Function) {
		super(MvcTraceActions.MESSENGER_REMOVEHANDLER, moduleName);
		type = $type;
		handler = $handler;
	}
	
	override public function toString():String {
		return "••<- " + MvcTraceActions.MESSENGER_REMOVEHANDLER + " > type : " + type + "     {" + moduleName + "}";
	}
}
}