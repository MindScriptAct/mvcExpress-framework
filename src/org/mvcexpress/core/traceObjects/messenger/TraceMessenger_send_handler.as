// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.messenger {
import org.mvcexpress.core.ModuleBase;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;
import org.mvcexpress.mvc.Command;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.mvc.Proxy;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceMessenger_send_handler extends TraceObj {
	
	public var type:String;
	public var params:Object;
	public var handler:Function;
	public var handlerClassName:String;
	
	public var messageFromModule:ModuleBase;
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