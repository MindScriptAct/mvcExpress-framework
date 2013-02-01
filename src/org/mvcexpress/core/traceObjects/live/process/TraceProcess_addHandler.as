// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.live.process {
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;
import org.mvcexpress.live.Process;
import org.mvcexpress.mvc.Mediator;

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
		super(MvcTraceActions.PROCESS_ADDHANDLER, moduleName);
		processObject = $processObject;
		type = $type;
		handler = $handler;
		//
		canPrint = false;
	}

}
}