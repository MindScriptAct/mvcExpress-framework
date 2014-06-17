package mvcexpress.extensions.workers.modules {
import flash.utils.ByteArray;

import mvcexpress.MvcExpress;
import mvcexpress.core.ExtensionManager;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.workers.core.CommandMapWorker;
import mvcexpress.extensions.workers.core.WorkerManager;
import mvcexpress.extensions.workers.core.traceObjects.moduleBase.TraceModuleBase_sendWorkerMessage;
import mvcexpress.modules.ModuleCore;


/**
 * @version workers.2.0 RC4
 */

public class ModuleWorker extends ModuleCore {

	// worker support

	// true if workers are supported.
	private static var _isSupported:Boolean;// = false;

	/** Instance of commandMap, typed as CommandMapWorker. (shortcut for 'commandMap as CommandMapWorker') */
	protected var commandMapWorker:CommandMapWorker;

	/** INTERNAL **/
	private var canCreateModule:Boolean;

	/**
	 * CONSTRUCTOR. ModuleName must be provided.
	 * @inheritDoc
	 */
	public function ModuleWorker(moduleName:String, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {
		use namespace pureLegsCore;

		CONFIG::debug {
			enableExtension(EXTENSION_WORKER_ID);
		}

		_isSupported = WorkerManager.isSupported;

		// stores if this module will be created. (then same swf file is used to create other modules - main module will not be created.)
		canCreateModule = true;

		if (_isSupported) {
			canCreateModule = WorkerManager.initWorker(moduleName);
		}

		if (canCreateModule) {
			if (!commandMapClass) {
				commandMapClass = CommandMapWorker;
			}
			super(moduleName, mediatorMapClass, proxyMapClass, commandMapClass, messengerClass);
		}
	}

	override pureLegsCore function prepareModule():void {
		if (canCreateModule) {
			commandMapWorker = commandMap as CommandMapWorker;
		}
	}

	/**
	 * Set root swf file Bytes. (used toe create workers from self. Alternative to loading worker swf file.)
	 * @param rootSwfBytes
	 */
	public function setRootSwfBytes(rootSwfBytes:ByteArray):void {
		WorkerManager.pureLegsCore::setRootSwfBytes(rootSwfBytes);
	}

	//-------------------------
	// start/terminate worker
	//-------------------------

	/**
	 * Starts background worker.
	 *        If workerSwfBytes property is not provided - rootSwfBytes will be used.
	 * @param workerModuleClass
	 * @param workerModuleName
	 * @param workerSwfBytes    bytes of loaded swf file.
	 */
	public function startWorker(workerModuleClass:Class, workerModuleName:String, workerSwfBytes:ByteArray = null, giveAppPrivileges:Boolean = false):void {
		use namespace pureLegsCore;

		// DOIT : implement optional module parameters for extendability.
		WorkerManager.startWorker(moduleName, workerModuleClass, workerModuleName, workerSwfBytes, giveAppPrivileges);
	}

	/**
	 * terminates background worker and dispose worker module.
	 * @param workerModuleName
	 */
	public function terminateWorker(workerModuleName:String):void {
		use namespace pureLegsCore;

		WorkerManager.terminateWorker(moduleName, workerModuleName);
	}

	//-------------
	// check running workers
	//-------------

	/**
	 * Returns true if workers are supported.
	 */
	public static function get isSupported():Boolean {
		return _isSupported;
	}

	/**
	 * Checks if worker is created with given name.
	 * @param workerModuleName
	 */
	public function isWorkerCreated(workerModuleName:String):Boolean {
		use namespace pureLegsCore;

		return WorkerManager.isWorkerCreated(workerModuleName);
	}


	/**
	 * Gives string with list of all running workers.
	 * @return
	 */
	public function listWorkers():String {
		use namespace pureLegsCore;

		return WorkerManager.listWorkers();
	}

	//----------------------------------
	//   Worker MESSAGING
	//----------------------------------

	/**
	 * Sends message for other framework actors to react to.
	 * @param    type    type of the message. (Commands and handle functions must be mapped to type to be triggered.)
	 * @param    params    Object that will be send to Command execute() or to handle function as parameter.
	 */
	public function sendWorkerMessage(remoteWorkerModuleName:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendWorkerMessage(moduleName, this, type, params, true));
		}
		//
		WorkerManager.sendWorkerMessage(moduleName, remoteWorkerModuleName, type, params);
		//
		// clean up logging
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendWorkerMessage(moduleName, this, type, params, false));
		}
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore const EXTENSION_WORKER_ID:int = ExtensionManager.getExtensionIdByName(pureLegsCore::EXTENSION_WORKER_NAME);

	/** @private */
	CONFIG::debug
	static pureLegsCore const EXTENSION_WORKER_NAME:String = "workers";

}
}
