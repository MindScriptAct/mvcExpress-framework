// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.messenger {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceMessenger_send extends TraceObj {
	
	public var type:String;
	public var params:Object;
	
	public function TraceMessenger_send(moduleName:String, $type:String, $params:Object) {
		super(MvcTraceActions.MESSENGER_SEND, moduleName);
		type = $type;
		params = $params;
	}
	
	override public function toString():String {
		return "•> " + MvcTraceActions.MESSENGER_SEND + " > type : " + type + ", params : " + params + "     {" + moduleName + "}";
	}
}
}