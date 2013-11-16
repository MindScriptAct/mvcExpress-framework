// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.workers.core {
import flash.utils.Dictionary;

import mvcexpress.core.*;
import mvcexpress.core.messenger.HandlerVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.workers.modules.ModuleWorker;
import mvcexpress.extensions.workers.mvc.CommandWorker;
import mvcexpress.mvc.Command;

use namespace pureLegsCore;

/**
 * Handles command mappings, and executes them on constants
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version scoped.1.0.beta2
 */
public class CommandMapWorker extends CommandMap {

	protected var workerHandlers:Vector.<HandlerVO> = new Vector.<HandlerVO>();

	/** CONSTRUCTOR */
	public function CommandMapWorker($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap, $mediatorMap:MediatorMap) {
		super($moduleName, $messenger, $proxyMap, $mediatorMap);
	}


	//----------------------------------
	//     set up commands to execute scoped constants
	//----------------------------------

	/**
	 * Maps a class for module to module communication, to be executed then message with provided type is sent from remote module with given module name.            <br>
	 * Only one command can be mapped to single messageType, for single scope. Unless canMapOver set to true - error will be thrown if you attempt to map second command class to same message type.
	 * @param    remoteWorkerModuleName            name of remote worker module, to handle command from.
	 * @param    type                Message type for command class to react to.
	 * @param    commandClass        Command class that will be executed.
	 * @param    canMapOver          Allows mapping command class over already existing command.
	 */
	public function workerMap(remoteWorkerModuleName:String, type:String, commandClass:Class, canMapOver:Boolean = false):void {
		use namespace pureLegsCore;

		//
		var scopedType:String = remoteWorkerModuleName + "_^~_" + type;

		if (classRegistry[scopedType]) {
			if (!canMapOver) {
				throw Error("Only one command class can be mapped to one message type. You are trying to map " + commandClass + " to " + type + " with scope " + remoteWorkerModuleName + ", but it is already mapped to " + classRegistry[type]);
			}
		} else {
			workerHandlers[workerHandlers.length] = WorkerManager.workerCommandMap(moduleName, handleCommandExecute, remoteWorkerModuleName, type, commandClass)
		}

		classRegistry[scopedType] = commandClass;
	}

	/**
	 * Unmaps a class for module to module communication, to be executed then message with provided type is sent from remote worker module.
	 * @param    remoteWorkerModuleName            name of remote worker module, to handle command from.
	 * @param    type                Message type for command class to react to.
	 * @param    commandClass        Command class that would be executed.
	 */
	public function workerUnmap(remoteWorkerModuleName:String, type:String):void {
		var scopedType:String = remoteWorkerModuleName + "_^~_" + type;

		var messageClass:Class = classRegistry[scopedType];
		if (messageClass) {
			WorkerManager.workerCommandUnmap(handleCommandExecute, remoteWorkerModuleName, type);
			delete classRegistry[scopedType];
		}
	}


	/** @private */
	override pureLegsCore function dispose():void {
		use namespace pureLegsCore;

		if (classRegistry) {

			for (var type:String in classRegistry) {
				var scopeTypeSplite:Array = type.split("_^~_");
				if (scopeTypeSplite.length > 1) {
					WorkerManager.workerCommandUnmap(handleCommandExecute, scopeTypeSplite[0], scopeTypeSplite[1]);
				} else {
					messenger.removeHandler(type, handleCommandExecute);
				}
			}
			classRegistry = null;
		}

		//
		var scopeHandlerCount:int = workerHandlers.length;
		for (var i:int; i < scopeHandlerCount; i++) {
			workerHandlers[i].handler = null;
		}
		workerHandlers = null;

		super.dispose()
	}


	override protected function prepareCommand(command:Command, commandClass:Class):void {
		if (command is CommandWorker) {
			(command as CommandWorker).commandMapWorker = this;
		}
		super.prepareCommand(command, commandClass);
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	override pureLegsCore function setSupportedExtensions(supportedExtensions:Dictionary):void {
		super.setSupportedExtensions(supportedExtensions);
		if (!SUPPORTED_EXTENSIONS[ModuleWorker.EXTENSION_WORKER_ID]) {
			throw Error("This extension is not supported by current module. You need " + ModuleWorker.EXTENSION_WORKER_NAME + " extension enabled.");
		}
	}
}
}