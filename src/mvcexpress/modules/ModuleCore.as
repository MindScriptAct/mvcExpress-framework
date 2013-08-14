// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.modules {
import flash.utils.Dictionary;

import mvcexpress.MvcExpress;
import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ModuleManager;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.moduleBase.TraceModuleBase_sendMessage;
import mvcexpress.utils.checkClassSuperclass;

/**
 * Core Module class, represents single application unit in mvcExpress framework.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands to do it)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleCore {

	// name of the module
	private var _moduleName:String;

	/** for communication. */
	pureLegsCore var messenger:Messenger;

	/** Handles application Proxies. */
	protected var proxyMap:ProxyMap;
	/** Handles application Mediators. */
	protected var mediatorMap:MediatorMap;
	/** Handles application Commands. */
	protected var commandMap:CommandMap;


	/**
	 * CONSTRUCTOR
	 * @param moduleName        module name that is used for referencing a module. (if not provided - unique name will be generated automatically.)
	 * @param extendedMediatorMapClass  OPTIONAL class to change default MediatorMap class. (For advanced users only.)
	 * @param extendedProxyMapClass     OPTIONAL class to change default ProxyMap class. (For advanced users only.)
	 * @param extendedCommandMapClass   OPTIONAL class to change default CommandMap class. (For advanced users only.)
	 * @param extendedMessengerClass    OPTIONAL class to change default Messenger class. (For advanced users only.)
	 */
	public function ModuleCore(moduleName:String = null, extendedMediatorMapClass:Class = null, extendedProxyMapClass:Class = null, extendedCommandMapClass:Class = null, extendedMessengerClass:Class = null) {
		use namespace pureLegsCore;

		CONFIG::debug {
			enableExtension(EXTENSION_CORE_ID);
		}

		if (!extendedMediatorMapClass) {
			extendedMediatorMapClass = MediatorMap;
		} else {
			CONFIG::debug {
				if (!checkClassSuperclass(extendedMediatorMapClass, "mvcexpress.core::MediatorMap", true)) {
					throw Error("ModuleCore can use only mediatorMapClass that extends MediatorMap. (" + extendedMediatorMapClass + " will not work)");
				}
			}
		}
		if (!extendedProxyMapClass) {
			extendedProxyMapClass = ProxyMap;
		} else {
			CONFIG::debug {
				if (!checkClassSuperclass(extendedProxyMapClass, "mvcexpress.core::ProxyMap", true)) {
					throw Error("ModuleCore can use only proxyMapClass that extends ProxyMap. (" + extendedProxyMapClass + " will not work)");
				}
			}
		}
		if (!extendedCommandMapClass) {
			extendedCommandMapClass = CommandMap;
		} else {
			CONFIG::debug {
				if (!checkClassSuperclass(extendedCommandMapClass, "mvcexpress.core::CommandMap", true)) {
					throw Error("ModuleCore can use only commandMapClass that extends CommandMap. (" + extendedCommandMapClass + " will not work)");
				}
			}
		}
		if (!extendedMessengerClass) {
			extendedMessengerClass = Messenger;
		} else {
			CONFIG::debug {
				if (!checkClassSuperclass(extendedMessengerClass, "mvcexpress.core.messenger::Messenger", true)) {
					throw Error("ModuleCore can use only messengerClass that extends Messenger. (" + extendedMessengerClass + " will not work)");
				}
			}
		}

		// register module with ModuleManager. (And get module name if it is not provided.)
		_moduleName = ModuleManager.registerModule(moduleName, this);

		// create module messenger.
		Messenger.allowInstantiation = true;
		messenger = new extendedMessengerClass(_moduleName);
		Messenger.allowInstantiation = false;

		// create module proxyMap
		proxyMap = new extendedProxyMapClass(_moduleName, messenger);

		// create module mediatorMap
		mediatorMap = new extendedMediatorMapClass(_moduleName, messenger, proxyMap);

		// create module commandMap
		commandMap = new extendedCommandMapClass(_moduleName, messenger, proxyMap, mediatorMap);
		proxyMap.setCommandMap(commandMap);

		onInit();

		CONFIG::debug {
			messenger.setSupportedExtensions(SUPPORTED_EXTENSIONS);
			proxyMap.setSupportedExtensions(SUPPORTED_EXTENSIONS);
			mediatorMap.setSupportedExtensions(SUPPORTED_EXTENSIONS);
			commandMap.setSupportedExtensions(SUPPORTED_EXTENSIONS);
		}
	}

	/**
	 * Function called after framework is initialized.
	 * Meant to be overridden.
	 */
	protected function onInit():void {
		// for override
	}

	/**
	 * Name of the module
	 */
	public function get moduleName():String {
		return _moduleName;
	}

	/**
	 * Function to get rid of module.
	 * - All module commands are unmapped.
	 * - All module mediators are unmediated
	 * - All module proxies are unmapped
	 * - All internals are nulled.
	 */
	public function disposeModule():void {
		onDispose();

		use namespace pureLegsCore;

		//
		commandMap.dispose();
		commandMap = null;

		mediatorMap.dispose();
		mediatorMap = null;

		proxyMap.dispose();
		proxyMap = null;

		messenger.dispose();
		messenger = null;
		//
		ModuleManager.disposeModule(_moduleName);

		CONFIG::debug {
			SUPPORTED_EXTENSIONS = null;
		}
	}

	/**
	 * Function called before module is destroyed.
	 * Meant to be overridden.
	 */
	protected function onDispose():void {
		// for override
	}


	//----------------------------------
	//     MESSAGING
	//----------------------------------

	/**
	 * Message sender.
	 * @param    type    type of the message. (Commands and handle functions must bu map to it to react.)
	 * @param    params    Object that will be send to Command execute() or to handle function as parameter.
	 */
	public function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendMessage(_moduleName, this, type, params, true));
		}
		//
		messenger.send(type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendMessage(_moduleName, this, type, params, false));
		}
	}

	//----------------------------------
	//     Execute module command.
	//----------------------------------

	/**
	 * Instantiates and executes provided command class, and sends params to it.
	 * @param    commandClass    Command class to be instantiated and executed.
	 * @param    params            Object to be sent to execute() function.
	 */
	public function executeCommand(commandClass:Class, params:Object = null):void {
		commandMap.execute(commandClass, params);
	}


	//----------------------------------
	//     Debug
	//----------------------------------

	public function listMessageCommands(messageType:String):String {
		use namespace pureLegsCore;

		return "SENDING MESSAGE:'" + messageType + "'\t> WILL EXECUTE  > " + String(commandMap.listMessageCommands(messageType)) + "\n";
	}

	/**
	 * List all message mappings.
	 */
	public function listMappedMessages():String {
		use namespace pureLegsCore;

		return messenger.listMappings(commandMap);
	}

	/**
	 * List all view mappings.
	 */
	public function listMappedMediators():String {
		return mediatorMap.listMappings();
	}

	/**
	 * List all model mappings.
	 */
	public function listMappedProxies():String {
		return proxyMap.listMappings();
	}

	/**
	 * List all controller mappings.
	 */
	public function listMappedCommands():String {
		return commandMap.listMappings();
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	protected var SUPPORTED_EXTENSIONS:Dictionary;

	CONFIG::debug
	protected function enableExtension(extensionId:int):void {
		if (SUPPORTED_EXTENSIONS == null) {
			SUPPORTED_EXTENSIONS = new Dictionary();
		}
		SUPPORTED_EXTENSIONS[extensionId] = true;
	}


	CONFIG::debug
	static public const EXTENSION_CORE_ID:int = ModuleManager.getExtensionId(EXTENSION_CORE_NAME);

	CONFIG::debug
	static public const EXTENSION_CORE_NAME:String = "CORE";


}
}