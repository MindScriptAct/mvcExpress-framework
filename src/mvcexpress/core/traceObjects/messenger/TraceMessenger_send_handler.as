// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.messenger {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.modules.ModuleCore;
import mvcexpress.mvc.Command;
import mvcexpress.mvc.Mediator;
import mvcexpress.mvc.Proxy;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceMessenger_send_handler extends TraceObj {

	public var type:String;
	public var params:Object;
	public var handler:Function;
	public var handlerClassName:String;

	public var messageFromModule:ModuleCore;
	public var messageFromMediator:Mediator;
	public var messageFromProxy:Proxy;
	public var messageFromCommand:Command;

	public function TraceMessenger_send_handler(moduleName:String, $type:String, $params:Object, $handler:Function, $handlerClassName:String) {
		use namespace pureLegsCore;

		super(MvcTraceActions.MESSENGER_SEND_HANDLER, moduleName);
		type = $type;
		params = $params;
		handler = $handler;
		handlerClassName = $handlerClassName;
		//
		canPrint = false;
	}

}
}