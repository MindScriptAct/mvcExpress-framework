// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.mediator {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj_SendMessage;
import mvcexpress.mvc.Mediator;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceMediator_sendScopeMessage extends TraceObj_SendMessage {

	public var type:String;
	public var params:Object;

	public function TraceMediator_sendScopeMessage(moduleName:String, $mediatorObject:Mediator, $type:String, $params:Object, preSend:Boolean) {
		use namespace pureLegsCore;

		super(((preSend) ? MvcTraceActions.MEDIATOR_SENDSCOPEMESSAGE : MvcTraceActions.MEDIATOR_SENDSCOPEMESSAGE_CLEAN), moduleName);
		mediatorObject = $mediatorObject;
		type = $type;
		params = $params;
		//
		canPrint = false;
	}

}
}