// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.live.process {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProcess_removeAllTasks extends TraceObj {
	
	public function TraceProcess_removeAllTasks(action:String, moduleName:String) {
		super(action, moduleName);
	}
	
	override public function toString():String {
		return "ÆÆ-- " + MvcTraceActions.PROCESS_REMOVEALLTASKS + "     {" + moduleName + "}";
	}

}
}