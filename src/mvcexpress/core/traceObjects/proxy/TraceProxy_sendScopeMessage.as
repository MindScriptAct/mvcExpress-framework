// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.proxy {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj_SendMessage;
import mvcexpress.mvc.Proxy;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceProxy_sendScopeMessage extends TraceObj_SendMessage {

	public var type:String;
	public var params:Object;

	public function TraceProxy_sendScopeMessage(moduleName:String, $proxyObject:Proxy, $type:String, $params:Object, preSend:Boolean) {
		use namespace pureLegsCore;

		super(((preSend) ? MvcTraceActions.PROXY_SENDSCOPEMESSAGE : MvcTraceActions.PROXY_SENDSCOPEMESSAGE_CLEAN), moduleName);
		proxyObject = $proxyObject;
		type = $type;
		params = $params;
		//
		canPrint = false;
	}

}
}