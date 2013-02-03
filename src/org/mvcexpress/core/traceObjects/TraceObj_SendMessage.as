// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import org.mvcexpress.core.ModuleBase;
import org.mvcexpress.live.Process;
import org.mvcexpress.mvc.Command;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.mvc.Proxy;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceObj_SendMessage extends TraceObj {
	
	public var moduleObject:ModuleBase;
	public var commandObject:Command;
	public var proxyObject:Proxy;
	public var mediatorObject:Mediator;
	public var processObject:Process;
	
	public function TraceObj_SendMessage(action:String, moduleName:String) {
		super(action, moduleName);
		//
		canPrint = false;
	}

}
}