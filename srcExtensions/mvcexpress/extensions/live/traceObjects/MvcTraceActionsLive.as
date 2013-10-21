// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.traceObjects {
import mvcexpress.core.namespace.pureLegsCore;

/**
 * Trace action id's.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version live.1.0.beta2
 */
public class MvcTraceActionsLive {

	static public const PROCESS_ADDTASK:String = "Process.addTask";
	static public const PROCESS_ADDFIRSTTASK:String = "Process.addFirstTask";
	static public const PROCESS_ADDTASKAFTER:String = "Process.addTaskAfter";
	static public const PROCESS_REMOVETASK:String = "Process.removeTask";
	static public const PROCESS_REMOVEALLTASKS:String = "Process.removeAllTasks";
	static public const PROCESS_ENABLETASK:String = "Process.enableTask";
	static public const PROCESS_DISABLETASK:String = "Process.disableTask";

	static public const PROCESSMAP_PROVIDE:String = "ProcessMap.provide";
	static public const PROCESSMAP_UNPROVIDE:String = "ProcessMap.unprovide";


	static pureLegsCore const PROCESS_INSTANT_SENDMESSAGE:String = "Process.runProcess.instantSendMessage";
	static pureLegsCore const PROCESS_INSTANT_SENDMESSAGE_CLEAN:String = "Process.runProcess.instantSendMessage.CLEAN";

	static pureLegsCore const PROCESS_POST_SENDMESSAGE:String = "Process.runProcess.postSendMessage";
	static pureLegsCore const PROCESS_POST_SENDMESSAGE_CLEAN:String = "Process.runProcess.postSendMessage.CLEAN";

	static pureLegsCore const PROCESS_FINAL_SENDMESSAGE:String = "Process.runProcess.finalSendMessage";
	static pureLegsCore const PROCESS_FINAL_SENDMESSAGE_CLEAN:String = "Process.runProcess.finalSendMessage.CLEAN";

	static public const PROCESS_ADDHANDLER:String = "Process.addHandler";


}
}