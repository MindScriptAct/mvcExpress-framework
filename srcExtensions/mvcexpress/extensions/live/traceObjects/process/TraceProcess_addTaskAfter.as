// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.traceObjects.process {
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.extensions.live.traceObjects.MvcTraceActionsLive;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version live.1.0.beta2
 */
public class TraceProcess_addTaskAfter extends TraceObj {

	public var taskClass:Class;
	public var name:String;
	public var skip:Boolean;

	public function TraceProcess_addTaskAfter(action:String, moduleName:String, $taskClass:Class, $name:String, $skip:Boolean = false) {
		super(action, moduleName);
		skip = $skip;
		taskClass = $taskClass;
		name = $name;
	}

	override public function toString():String {
		if (skip) {
			return "ÆÆÆ+ " + MvcTraceActionsLive.PROCESS_ADDTASKAFTER + "WARNING!: this task is already added. > taskClass : " + taskClass + ", name : " + name + "     {" + moduleName + "}";
		}
		return "ÆÆÆ+ " + MvcTraceActionsLive.PROCESS_ADDTASKAFTER + " > taskClass : " + taskClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}