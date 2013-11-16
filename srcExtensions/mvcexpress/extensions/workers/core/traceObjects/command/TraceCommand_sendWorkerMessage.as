// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.workers.core.traceObjects.command {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj_SendMessage;
import mvcexpress.mvc.Command;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceCommand_sendWorkerMessage extends TraceObj_SendMessage {

	public var type:String;
	public var params:Object;

	public function TraceCommand_sendWorkerMessage(moduleName:String, $commandObject:Command, $type:String, $params:Object, preSend:Boolean) {
		use namespace pureLegsCore;

		super(((preSend) ? MvcTraceActions.COMMAND_SENDSCOPEMESSAGE : MvcTraceActions.COMMAND_SENDSCOPEMESSAGE_CLEAN), moduleName);
		commandObject = $commandObject;
		type = $type;
		params = $params;
		//
		canPrint = false;
	}

}
}