// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.dlc.live.traceObjects.process {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.dlc.live.traceObjects.MvcTraceActionsLive;
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.dlc.live.Process;
import mvcexpress.dlc.live.mvc.MediatorLive;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProcess_addHandler extends TraceObj {

	public var type:String;
	public var handler:Function;
	public var processObject:Process;

	public function TraceProcess_addHandler(moduleName:String, $processObject:Process, $type:String, $handler:Function) {
		use namespace pureLegsCore;
		super(MvcTraceActionsLive.PROCESS_ADDHANDLER, moduleName);
		processObject = $processObject;
		type = $type;
		handler = $handler;
		//
		canPrint = false;
	}

}
}