// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.dlc.live.traceObjects.process {
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.dlc.live.traceObjects.MvcTraceActionsLive;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProcess_enableTask extends TraceObj {

	public var taskClass:Class;
	public var name:String;

	public function TraceProcess_enableTask(action:String, moduleName:String, $taskClass:Class, $name:String) {
		super(action, moduleName);
		taskClass = $taskClass;
		name = $name;
	}

	override public function toString():String {
		return "ÆÆÆ* " + MvcTraceActionsLive.PROCESS_ENABLETASK + " > taskClass : " + taskClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}