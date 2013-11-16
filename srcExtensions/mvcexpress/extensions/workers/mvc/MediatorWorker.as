// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.workers.mvc {
import mvcexpress.MvcExpress;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.workers.core.WorkerManager;
import mvcexpress.extensions.workers.core.traceObjects.mediator.TraceMediator_sendWorkerMessage;
import mvcexpress.extensions.workers.modules.ModuleWorker;
import mvcexpress.mvc.Mediator;

use namespace pureLegsCore;

/**
 * Mediates single view object.                                                                                                                            </br>
 *  Main responsibility of mediator is to send message from framework  to view, and receive constants from view and send to framework.                        </br>
 *  Can get proxies injected.                                                                                                                                </br>
 *  Can send constants. (sends constants then user interacts with the view)                                                                                    </br>
 *  Can handle constants. (handles data change or other framework constants)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version workers.2.0.rc1
 */
public class MediatorWorker extends Mediator {


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
			MvcExpress.debug(new TraceMediator_sendWorkerMessage(moduleName, this, type, params, true));
		}
		//
		WorkerManager.sendWorkerMessage(moduleName, remoteWorkerModuleName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceMediator_sendWorkerMessage(moduleName, this, type, params, false));
		}
	}

	//----------------------------------
	//     worker message handling
	//----------------------------------

	/**
	 * Adds worker module to module communication handle function to be called then message is send from remote worker.
	 * @param    remoteWorkerModuleName    name of remote worker module, to handle message from.
	 * @param    type        type    message type for handle function to react to.
	 * @param    handler        function that will be called then needed message is sent. this function must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
	 */
	protected function addWorkerHandler(remoteWorkerModuleName:String, type:String, handler:Function):void {
		use namespace pureLegsCore;

		handlerVoRegistry[handlerVoRegistry.length] = WorkerManager.addWorkerHandler(moduleName, remoteWorkerModuleName, type, handler);
	}

	/**
	 * Removes worker module to module communication handle function.
	 * @param    remoteWorkerModuleName    name of remote worker module, to handle message from.
	 * @param    type        type    message type for handle function to react to.
	 * @param    handler        function that will be called then needed message is sent. this function must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
	 */
	protected function removeWorkerHandler(remoteWorkerModuleName:String, type:String, handler:Function):void {
		use namespace pureLegsCore;

		WorkerManager.removeWorkerHandler(remoteWorkerModuleName, type, handler);
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