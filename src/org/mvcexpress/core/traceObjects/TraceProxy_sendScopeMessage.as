// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProxy_sendScopeMessage extends TraceObj_SendMessage {
	
	public var type:String;
	public var params:Object;
	
	public function TraceProxy_sendScopeMessage(action:String, moduleName:String, proxyObject:Proxy, type:String, params:Object) {
		super(action, moduleName);
		this.proxyObject = proxyObject;
		this.type = type;
		this.params = params;
		//
		canPrint = false;
	}

}
}