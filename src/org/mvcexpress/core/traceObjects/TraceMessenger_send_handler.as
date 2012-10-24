// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import org.mvcexpress.core.ModuleBase;
import org.mvcexpress.mvc.Command;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
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
	
	public function TraceMessenger_send_handler(action:String, moduleName:String, type:String, params:Object, handler:Function, handlerClassName:String) {
		super(action, moduleName);
		this.type = type;
		this.params = params;
		this.handler = handler;
		this.handlerClassName = handlerClassName;
		//
		canPrint = false;
	}

}
}