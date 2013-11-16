package mvcexpress.extensions.workers.core {
import flash.events.Event;
import flash.net.getClassByAlias;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mvcexpress.core.messenger.HandlerVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.workers.core.messenger.WorkerMessenger;
import mvcexpress.extensions.workers.data.ClassAliasRegistry;
import mvcexpress.modules.ModuleCore;

/**
 * Manages workers.
 * @private
 */
public class WorkerManager {

	/**
	 * If set to true, class aliases will be registered before sending between modules. (untyped objects will be sent otherwise)
	 */
	static public var doAutoRegisterClasses:Boolean = true;


	// true if workers are supported.
	private static var _isWorkersSupported:Boolean;

	// stores worker classes dynamically.
	public static var WorkerClass:Class;
	public static var WorkerDomainClass:Class;

	// root class bytes.
	static private var $primordialSwfBytes:ByteArray;


	///// keys for worker shared data.
	// name of worker module,  every worker have only one worker Module.
	private static const WORKER_MODULE_NAME_KEY:String = "$_wmn_$";
	// class name of remote module. (used by remote worker to instantiate remote module)
	pureLegsCore static const REMOTE_MODULE_CLASS_NAME_KEY:String = "$_rmcn_$";
	// all class alias names to register.
	private static const CLASS_ALIAS_NAMES_KEY:String = "$_can_$";

	///// worker communication types.
	// init remote worker.
	private static const INIT_REMOTE_WORKER_TYPE:String = "$_irw_t_$";
	// sends message to all worker.
	private static const SEND_WORKER_MESSAGE_TYPE:String = "$_sm_t_$";
	// register class alias, from another worker.
	private static const REGISTER_CLASS_ALIAS_TYPE:String = "$_rca_t_$";

	// worker to remote channel naming
	private static const WORKER_TO_REMOTE_CHANNEL:String = "workerToRemote_";
	// remote to worker channel naming
	private static const REMOTE_TO_WORKER_CHANNEL:String = "remoteToWorker_";
	// this to worker channel naming
	private static const THIS_TO_WORKER_CHANNEL:String = "thisToWorker_";
	// worker to this channel naming
	private static const WORKER_TO_THIS_CHANNEL:String = "workerToThis_";


	// list of worker names with ready communication channels.
	static private var $channelReadyWorkerNames:Vector.<String> = new <String>[];

	// channels to all remote workers.
	static private var $sendMessageChannels:Vector.<Object> = new <Object>[];
	static private var $sendMessageChannelsRegistry:Dictionary = new Dictionary();

	// channels from all remote workers.
	static private var $receiveMessageChannels:Vector.<Object> = new <Object>[];

	// registry of all workers.
	static private var $workerRegistry:Dictionary = new Dictionary()

	/* all messengers by remote worker module name */
	static private var workerMessengers:Dictionary = new Dictionary(); //* of WorkerMessenger by String{moduleName} */

	//  messenger  waiting for remote worker to be initialized. (All messages send while waiting will be stacked, and send then remote module is ready.)
	static private var $pendingWorkerMessengers:Dictionary = new Dictionary();

	// store messageChannels so they don't get garbage collected while they are waiting for remote worker to be ready.
	static private var $tempChannelStorage:Vector.<Object> = new <Object>[];


	/**
	 * True if workers are supported.
	 */
	public static function get isWorkersSupported():Boolean {
		return _isWorkersSupported;
	}


	/**
	 * Set root swf file Bytes. (used toe create workers from self, as alternative to leading it.)
	 * @param rootSwfBytes
	 */
	public static function setRootSwfBytes(rootSwfBytes:ByteArray):void {
		$primordialSwfBytes = rootSwfBytes;
	}


	static pureLegsCore function checkWorkerSupport():Boolean {
		use namespace pureLegsCore;

		try {
			// dynamically get worker classes.
			WorkerClass = getDefinitionByName("flash.system.Worker") as Class;
			WorkerDomainClass = getDefinitionByName("flash.system.WorkerDomain") as Class;
		} catch (error:Error) {
			// do nothing.
		}

		if (WorkerClass && WorkerDomainClass && WorkerClass.isSupported) {
			_isWorkersSupported = true;
		}

		return _isWorkersSupported;
	}

	/**
	 * Starts background worker.
	 *        If workerSwfBytes property is not provided - rootSwfBytes will be used.
	 * @param workerModuleClass
	 * @param remoteModuleName
	 * @param workerSwfBytes
	 *
	 * @private
	 */
	static pureLegsCore function startWorker(mainModuleName:String, workerModuleClass:Class, remoteModuleName:String, workerSwfBytes:ByteArray = null):void {
		use namespace pureLegsCore;

		// TODO : check extended form workerModule class.

		if (_isWorkersSupported) {
			if (WorkerClass.current.isPrimordial) {

				if ($workerRegistry[remoteModuleName]) {
					throw Error("WorkerModule with name:" + remoteModuleName + " is already started. Please terminate it before starting new one.");
				}

				var remoteWorker:Object;
				if (workerSwfBytes) {
					remoteWorker = WorkerDomainClass.current.createWorker(workerSwfBytes);
				} else if ($primordialSwfBytes) {
					remoteWorker = WorkerDomainClass.current.createWorker($primordialSwfBytes);
				} else {
					throw Error("Worker needs swf bytes to be constructed. You can pass it as 'workerSwfBytes' or set it from Main class with: WorkerManager.setRootSwfBytes(this.loaderInfo.bytes);");
				}
				$workerRegistry[remoteModuleName] = remoteWorker;

				remoteWorker.setSharedProperty(REMOTE_MODULE_CLASS_NAME_KEY, getQualifiedClassName(workerModuleClass));

				// custom class aliases that needs to be geristered by remote worker.
				var classAliasNames:String = ClassAliasRegistry.getCustomClasses();
				remoteWorker.setSharedProperty(CLASS_ALIAS_NAMES_KEY, classAliasNames);

				// init custom worker messenger
				var messengerWorker:WorkerMessenger = getWorkerMessenger(remoteModuleName);
				$pendingWorkerMessengers[remoteModuleName] = messengerWorker;

				//
				connectRemoteWorker(remoteWorker, mainModuleName);
				//
				remoteWorker.start();

			} else {
				throw Error("Starting other workers only possible from main(primordial) worker.)");
			}
		} else {
			var remoteModule:Object = new workerModuleClass();

			var mainMessenger:WorkerMessenger = getWorkerMessenger(mainModuleName);
			mainMessenger.ready();
			var remoteMessenger:WorkerMessenger = getWorkerMessenger(remoteModuleName);
			remoteMessenger.ready();

		}
	}

	/**
	 * Tries to initialize main worker module,
	 *        or if it is copy of main swf - creates remote worker module.
	 * @param moduleName
	 * @param debug_objectID
	 * @return
	 *
	 * @private
	 */
	static pureLegsCore function initWorker(moduleName:String):Boolean {
		use namespace pureLegsCore;

		if (WorkerClass.current.isPrimordial) { // check if primordial.
			var rootModuleName:String = WorkerClass.current.getSharedProperty(WORKER_MODULE_NAME_KEY);
			if (rootModuleName != null) { // check if root module is already created.
				throw Error("Only first(main) ModuleWorker can be instantiated. Use startWorker(MyBackgroundWorkerModule) to create background workers. ");
			} else { // PRIMORDIAL, MAIN.

				CONFIG::debug {
					if (!moduleName) {
						throw Error("Worker must have not empty moduleName. (It is used for module to module communication.)");
					}
				}
				WorkerClass.current.setSharedProperty(WORKER_MODULE_NAME_KEY, moduleName);

			}
		} else {
			// not primordial workers.

			// check if child must be created.
			var childModuleClassDefinition:String = WorkerClass.current.getSharedProperty(REMOTE_MODULE_CLASS_NAME_KEY);


			if (childModuleClassDefinition) {
				// NOT PRIMORDIAL, COPY OF THE MAIN.

				WorkerClass.current.setSharedProperty(REMOTE_MODULE_CLASS_NAME_KEY, null);

				try {
					var childModuleClass:Class = getDefinitionByName(childModuleClassDefinition) as Class;
				} catch (error:Error) {
					throw Error("Failed to get a class from class definition: " + childModuleClassDefinition + " - " + error)
				}

				try {
					var childModule:Object = new childModuleClass();
				} catch (error:Error) {
					throw Error("Failed to construct class for: " + childModuleClass + " - " + error)
				}

				// return false, to end this module.
				return false;
			} else {
				// NOT PRIMORDIAL, CHILD MODULE.

				WorkerClass.current.setSharedProperty(WORKER_MODULE_NAME_KEY, moduleName);

				// register all already used class aliases.
				var classAliasNames:String = WorkerClass.current.getSharedProperty(CLASS_ALIAS_NAMES_KEY);
				if (classAliasNames != "") {
					var classAliasSplit:Array = classAliasNames.split(",");
					for (var i:int = 0; i < classAliasSplit.length; i++) {
						registerClassNameAlias(classAliasSplit[i])
					}
				}
				WorkerClass.current.setSharedProperty(CLASS_ALIAS_NAMES_KEY, null);

				setUpRemoteWorkerCommunication(moduleName);
			}
		}
		return true;
	}

	/**
	 * Stops background worker.s
	 * @param remoteWorkerName
	 */
	static pureLegsCore function terminateWorker(mainModuleName:String, remoteWorkerName:String):void {
		use namespace pureLegsCore;

		// todo : decide what to do, if current module name is sent.
		// todo : decide what to do if current worker is not primordial. (remote worker tries to terminate itself.)

		if (_isWorkersSupported) {
			var worker:Object = $workerRegistry[remoteWorkerName];
			if (worker) {

				// TODO : send message to other modules to remove channels with terminated worker.

				// clare chanels stored in shared properties and tempStoragge.
				var workerToRemote:Object = worker.getSharedProperty(WORKER_TO_REMOTE_CHANNEL + mainModuleName);
				if (workerToRemote) {
					workerToRemote.close();
					for (var i:int = 0; i < $tempChannelStorage.length; i++) {
						if ($tempChannelStorage[i] == workerToRemote) {
							$tempChannelStorage.splice(i, 1);
							break;
						}
					}
				}
				var remoteToWorker:Object = worker.getSharedProperty(REMOTE_TO_WORKER_CHANNEL + mainModuleName);
				if (remoteToWorker) {
					remoteToWorker.removeEventListener("channelMessage", handleChannelMessage);
					remoteToWorker.close();
					for (i = 0; i < $tempChannelStorage.length; i++) {
						if ($tempChannelStorage[i] == remoteToWorker) {
							$tempChannelStorage.splice(i, 1);
							break;
						}
					}
				}

				// remove channels from this module.
				for (i = 0; i < $channelReadyWorkerNames.length; i++) {
					if ($channelReadyWorkerNames[i] == remoteWorkerName) {
						var thisToWorker:Object = $sendMessageChannels.splice(i, 1)[0];
						thisToWorker.close();
						var workerToThis:Object = $receiveMessageChannels.splice(i, 1)[0];
						workerToThis.removeEventListener("channelMessage", handleChannelMessage);
						workerToThis.close();

						$channelReadyWorkerNames.splice(i, 1);
						break;
					}
				}

				worker.terminate();

				delete $workerRegistry[remoteWorkerName];
				delete $sendMessageChannelsRegistry[remoteWorkerName];
				delete $pendingWorkerMessengers[remoteWorkerName];
			}
		} else {
			if ($workerRegistry[remoteWorkerName]) {
				($workerRegistry[remoteWorkerName] as ModuleCore).disposeModule();
				delete $workerRegistry[remoteWorkerName]
			}
		}
	}


	static pureLegsCore function isWorkerCreated(workerModuleName:String):Boolean {
		return ($workerRegistry[workerModuleName] != null);
	}

	static pureLegsCore function listWorkers():String {
		var retVal:String = "";
		for (var workerName:String in $workerRegistry) {
			if (retVal != "") {
				retVal += ",";
			}
			retVal += workerName;
		}
		return retVal;
	}


	static private function connectRemoteWorker(remoteWorker:Object, debug_mainModuleName:String = null, debug_objectID:int = 0):void {
		use namespace pureLegsCore;

		// get all running workers
		var workers:* = WorkerDomainClass.current.listWorkers();
		//
		for (var i:int = 0; i < workers.length; i++) {
			var worker:Object = workers[i];
			//
			// get model name from worker.
			var workerModuleName:String = worker.getSharedProperty(WORKER_MODULE_NAME_KEY);
			//worker.setSharedProperty(WORKER_MODULE_NAME_KEY, workerModuleName);
			//
			if (!$sendMessageChannelsRegistry[workerModuleName]) {
				var workerToRemote:Object = worker.createMessageChannel(remoteWorker);
				var remoteToWorker:Object = remoteWorker.createMessageChannel(worker);

				// store so they don't get garabage collected.
				$tempChannelStorage.push(workerToRemote);
				$tempChannelStorage.push(remoteToWorker);

				//
				remoteWorker.setSharedProperty(WORKER_TO_REMOTE_CHANNEL + workerModuleName, workerToRemote);
				remoteWorker.setSharedProperty(REMOTE_TO_WORKER_CHANNEL + workerModuleName, remoteToWorker);

				//Listen to the response from our worker
				remoteToWorker.addEventListener("channelMessage", handleChannelMessage);

			}
		}
	}


	static private function setUpRemoteWorkerCommunication(remoteModuleName:String):void {
		// get all workers
		var workers:* = WorkerDomainClass.current.listWorkers();
		//
		var thisWorker:Object = WorkerClass.current;
		for (var i:int = 0; i < workers.length; i++) {
			var worker:Object = workers[i];
			// TODO : decide what to do with self send messages...
			if (worker != WorkerClass.current) {
				if (worker.isPrimordial) {

					var workerModuleName:String = worker.getSharedProperty(WORKER_MODULE_NAME_KEY);
					// handle communication permissions
					use namespace pureLegsCore;

					// init custom worker messenger
					getWorkerMessenger(workerModuleName).ready();

					//
					if (!$sendMessageChannelsRegistry[workerModuleName]) {
						var workerToThis:Object = thisWorker.getSharedProperty(WORKER_TO_REMOTE_CHANNEL + workerModuleName);
						var thisToWorker:Object = thisWorker.getSharedProperty(REMOTE_TO_WORKER_CHANNEL + workerModuleName);
						//
						$sendMessageChannelsRegistry[workerModuleName] = thisToWorker;

						$sendMessageChannels.push(thisToWorker);
						$receiveMessageChannels.push(workerToThis);
						$channelReadyWorkerNames.push(workerModuleName);

						workerToThis.addEventListener("channelMessage", handleChannelMessage);

						worker.setSharedProperty(THIS_TO_WORKER_CHANNEL + remoteModuleName, thisToWorker);
						worker.setSharedProperty(WORKER_TO_THIS_CHANNEL + remoteModuleName, workerToThis);

						thisToWorker.send(INIT_REMOTE_WORKER_TYPE);
						thisToWorker.send(remoteModuleName);
					} else {
						throw Error("2 workers with same name should not exist.");
					}
				}
			}
		}
	}


	//----------------------------
	// messages
	//----------------------------

	static pureLegsCore function sendWorkerMessageToRemoteChannel(destinationModule:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;

		if (_isWorkersSupported) {
			var msgChannel:Object = $sendMessageChannelsRegistry[destinationModule];
			if (msgChannel) {
				msgChannel.send(SEND_WORKER_MESSAGE_TYPE);
				msgChannel.send(type);
				if (params) {
					msgChannel.send(params);
				}
			}
		} else {
			var messageTypeSplit:Array = type.split("_^~_");
			var remoteMessenger:WorkerMessenger = getWorkerMessenger(messageTypeSplit[0]);
			remoteMessenger.send(type, params);
		}
	}


	static private function handleChannelMessage(event:Event):void {
		use namespace pureLegsCore;

		var channel:Object = event.target;

		if (channel.messageAvailable) {
			var communicationType:Object = channel.receive();

			if (communicationType == INIT_REMOTE_WORKER_TYPE) {
				// handle special communication for initialization of new worker.
				var remoteModuleName:String = channel.receive(true);

				var thisWorker:Object = WorkerClass.current;

				var workerToThis:Object = thisWorker.getSharedProperty(THIS_TO_WORKER_CHANNEL + remoteModuleName);
				var thisToWorker:Object = thisWorker.getSharedProperty(WORKER_TO_THIS_CHANNEL + remoteModuleName);

				$sendMessageChannelsRegistry[remoteModuleName] = thisToWorker;

				$sendMessageChannels.push(thisToWorker);
				$receiveMessageChannels.push(workerToThis);
				$channelReadyWorkerNames.push(remoteModuleName);

				// send pending messages.
				delete $pendingWorkerMessengers[remoteModuleName]
				// remove  channels from temporal storage.
				for (var i:int = 0; i < $tempChannelStorage.length; i++) {
					if ($tempChannelStorage[i] == thisToWorker) {
						$tempChannelStorage.splice(i, 1);
						i--;
					} else if ($tempChannelStorage[i] == workerToThis) {
						$tempChannelStorage.splice(i, 1);
						i--;
					}
				}

				// ready messenger.
				var workerMessenger:WorkerMessenger = workerMessengers[remoteModuleName];
				workerMessenger.ready();

			} else if (communicationType == REGISTER_CLASS_ALIAS_TYPE) {
				// handle special message for registering class alias.
				var classQualifiedName:String = channel.receive(true) as String;
				registerClassNameAlias(classQualifiedName);

			} else if (communicationType == SEND_WORKER_MESSAGE_TYPE) {
				// handle worker to worker communication.
				var messageType:String = channel.receive(true) as String;
				var params:Object = channel.receive(true);
				var messageTypeSplit:Array = messageType.split("_^~_");

				// TODO : rething if getting moduleName from worker valid here.(error scenarios?)
				var moduleName:String = WorkerClass.current.getSharedProperty(WORKER_MODULE_NAME_KEY);
				handleReceivedWorkerMessage(moduleName, messageTypeSplit[0], messageTypeSplit[1], params);

			} else {
				throw Error("WorkerManager can't handle communicationType:" + communicationType + " This channel designed to be used by framework only.");
			}
		}
	}

	private static function handleReceivedWorkerMessage(sourceModule:String, destinationModule:String, type:String, params:Object):void {
		use namespace pureLegsCore;

		// from outside to this...
		// get worker messenger, and trigger send.
		var workerMessenger:Messenger = workerMessengers[destinationModule];
		if (workerMessenger) {
			workerMessenger.send(destinationModule + "_^~_" + type, params);
		}
	}


	//----------------------------------
	//	worker messenger handling.
	//----------------------------------

	private static function getWorkerMessenger(remoteModuleName:String):WorkerMessenger {

		var workerMesanger:WorkerMessenger = workerMessengers[remoteModuleName];
		if (!workerMesanger) {
			use namespace pureLegsCore;

			Messenger.allowInstantiation = true;
			workerMesanger = new WorkerMessenger("$worker_" + remoteModuleName);
			Messenger.allowInstantiation = false;
			workerMessengers[remoteModuleName] = workerMesanger;
		}
		return workerMesanger;
	}


	static pureLegsCore function sendWorkerMessage(fromModule:String, toModule:String, type:String, params:Object):void {
		// from this to outside.
		var workerMessenger:WorkerMessenger = workerMessengers[toModule];
		if (workerMessenger) {
			workerMessenger.workerSend(toModule, fromModule + "_^~_" + type, params);
		}
	}

	static pureLegsCore function addWorkerHandler(moduleName:String, remoteModuleName:String, type:String, handler:Function):HandlerVO {
		var workerMessenger:WorkerMessenger = workerMessengers[remoteModuleName];
		if (!workerMessenger) {
			workerMessenger = getWorkerMessenger(remoteModuleName);
		}
		return workerMessenger.addHandler(remoteModuleName + "_^~_" + type, handler);

	}

	static pureLegsCore function removeWorkerHandler(remoteModuleName:String, type:String, handler:Function):void {
		var workerMessenger:WorkerMessenger = workerMessengers[remoteModuleName];
		if (workerMessenger) {
			workerMessenger.removeHandler(remoteModuleName + "_^~_" + type, handler);
		}
	}


	//------------------------------
	//	class alias handling.
	//------------------------------

	static private function registerClassNameAlias(classQualifiedName:String):void {
		use namespace pureLegsCore;

		//trace("Registering new class...", classQualifiedName);

		// check if alias is not already created.
		try {
			var mapClass:Class = getClassByAlias(classQualifiedName);
		} catch (error:Error) {
			// do noting
		}
		//trace("Alias clas exists?", mapClass)
		if (!mapClass) {
			// try to get it by definition...
			mapClass = getDefinitionByName(classQualifiedName) as Class;
			if (mapClass) {
				registerClassAlias(classQualifiedName, mapClass);
			} else {
				throw Error("Failed to find class with definition:" + classQualifiedName + " in " + "moduleName" + " add this class to project or use registerClassAlias(" + classQualifiedName + ", YourClass); to register alternative class. ");
			}
		}
		//trace("Class got by definition:", mapClass)
		ClassAliasRegistry.mapClassAlias(mapClass, classQualifiedName);
	}


	static pureLegsCore function startClassRegistration(classFullName:String):void {
		//trace(" !! startClassRegistration", classFullName);
		use namespace pureLegsCore;

		for (var i:int = 0; i < $sendMessageChannels.length; i++) {
			$sendMessageChannels[i].send(REGISTER_CLASS_ALIAS_TYPE);
			$sendMessageChannels[i].send(classFullName);
		}
	}


	//-----------------------------
	//	Command handling
	//-----------------------------

	public static function workerCommandMap(moduleName:String, handleCommandExecute:Function, remoteModuleName:String, type:String, commandClass:Class):HandlerVO {
		var workerMessenger:WorkerMessenger = workerMessengers[remoteModuleName];
		if (!workerMessenger) {
			workerMessenger = getWorkerMessenger(remoteModuleName);
		}
		return workerMessenger.addCommandHandler(remoteModuleName + "_^~_" + type, handleCommandExecute, commandClass);
	}

	public static function workerCommandUnmap(handleCommandExecute:Function, remoteModuleName:String, type:String):void {
		var scopeMessenger:Messenger = workerMessengers[remoteModuleName];
		if (scopeMessenger) {
			scopeMessenger.removeHandler(remoteModuleName + "_^~_" + type, handleCommandExecute);
		}
	}

}
}
