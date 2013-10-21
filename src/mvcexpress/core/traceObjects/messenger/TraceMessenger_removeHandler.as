// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.messenger {
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
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