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
public class TraceObj_SendMessage extends TraceObj {
	
	public var moduleObject:ModuleBase;
	public var commandObject:Command;
	public var proxyObject:Proxy;
	public var mediatorObject:Mediator;
	
	public function TraceObj_SendMessage(action:String, moduleName:String) {
		super(action, moduleName);
	}

}
}