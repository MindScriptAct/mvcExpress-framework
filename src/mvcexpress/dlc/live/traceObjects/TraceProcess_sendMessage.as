// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.dlc.live.traceObjects {
import mvcexpress.core.traceObjects.*;
import mvcexpress.dlc.live.Process;
import mvcexpress.dlc.live.mvc.MediatorLive;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProcess_sendMessage extends TraceObj_SendMessage {

	public var type:String;
	public var params:Object;

	private var processObject:Process;

	public function TraceProcess_sendMessage(action:String, moduleName:String, $processObject:Process, $type:String, $params:Object) {
		super(action, moduleName);
		processObject = $processObject;
		type = $type;
		params = $params;
		//
		canPrint = false;
	}

}
}