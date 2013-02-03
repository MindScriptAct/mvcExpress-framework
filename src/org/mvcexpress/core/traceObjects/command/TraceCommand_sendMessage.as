// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.command {
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj_SendMessage;
import org.mvcexpress.mvc.Command;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceCommand_sendMessage extends TraceObj_SendMessage {
	
	public var type:String;
	public var params:Object;
	
	public function TraceCommand_sendMessage(moduleName:String, $commandObject:Command, $type:String, $params:Object, preSend:Boolean) {
		use namespace pureLegsCore;
		super(((preSend) ? MvcTraceActions.COMMAND_SENDMESSAGE : MvcTraceActions.COMMAND_SENDMESSAGE_CLEAN), moduleName);
		commandObject = $commandObject;
		type = $type;
		params = $params;
		//
		canPrint = false;
	}

}
}