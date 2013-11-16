// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.workers.mvc {
import mvcexpress.MvcExpress;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.workers.core.WorkerManager;
import mvcexpress.extensions.workers.core.traceObjects.command.TraceCommand_sendWorkerMessage;
import mvcexpress.extensions.workers.modules.ModuleWorker;
import mvcexpress.mvc.*;

/**
 * Command that is automatically pooled.
 * All PooledCommand's are automatically pooled after execution for later reuse(except then they are locked)
 * You can lock() command to prevent it from being pooled after execute, locked commands are pooled after you unlock() it.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version workers.2.0.rc1
 */
public class PooledCommandWorker extends PooledCommand {

	//----------------------------------
	//     MESSAGING
	//----------------------------------

	/**
	 * Sends message from this worker to remote worker specified by worker name.
	 * @param    remoteWorkerModuleName    name of remote worker module, to send message to.
	 * @param    type        type of the message for Commands or Mediator's handle function to react to.
	 * @param    params        Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendWorkerMessage(remoteWorkerModuleName:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommand_sendWorkerMessage(messenger.moduleName, this, type, params, true));
		}
		//
		WorkerManager.sendWorkerMessage(messenger.moduleName, remoteWorkerModuleName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommand_sendWorkerMessage(messenger.moduleName, this, type, params, false));
		}
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleWorker.pureLegsCore::EXTENSION_WORKER_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleWorker.pureLegsCore::EXTENSION_WORKER_NAME;

}
}