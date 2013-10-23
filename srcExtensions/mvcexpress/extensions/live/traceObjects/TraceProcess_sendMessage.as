// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.traceObjects {
import mvcexpress.core.traceObjects.*;
import mvcexpress.extensions.live.engine.Process;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version live.1.0.beta2
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