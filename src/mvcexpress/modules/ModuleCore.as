// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.modules {
import flash.utils.Dictionary;

import mvcexpress.MvcExpress;
import mvcexpress.core.CommandMap;
import mvcexpress.core.ExtensionManager;
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
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class ModuleCore {

	// name of the module
	private var _moduleName:String;

	/** used internally for communication
	 * @private */
	pureLegsCore var messenger:Messenger;

	/** Handles application Proxies. */
	protected var proxyMap:ProxyMap;
	/** Handles application Mediators. */
	protected var mediatorMap:MediatorMap;
	/** Handles application Commands. */
	public var commandMap:CommandMap;


	/**
	 * CONSTRUCTOR
	 * @param moduleName        module name that is used for referencing a module. (if not provided - unique name will be generated automatically.)
	 * @param extendedMediatorMapClass  OPTIONAL class to change default MediatorMap class. (For advanced use only, like custom extensions.)
	 * @param extendedProxyMapClass     OPTIONAL class to change default ProxyMap class. (For advanced use only, like custom extensions.)
	 * @param extendedCommandMapClass   OPTIONAL class to change default CommandMap class. (For advanced use only, like custom extensions.)
	 * @param extendedMessengerClass    OPTIONAL class to change default Messenger class. (For advanced use only, like custom extensions.)
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

		CONFIG::debug {
			messenger.setSupportedExtensions(SUPPORTED_EXTENSIONS);
			proxyMap.setSupportedExtensions(SUPPORTED_EXTENSIONS);
			mediatorMap.setSupportedExtensions(SUPPORTED_EXTENSIONS);
			commandMap.setSupportedExtensions(SUPPORTED_EXTENSIONS);
		}

		onInit();
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
	 * Function to get rid of module.                                                                                            <p>
	 * - All module commands are unmapped.
	 * - All module mediators are unmediated
	 * - All module proxies are unmapped
	 * - All internals are set to null.                                                                                            </p>
	 */
	public function disposeModule():void {
		use namespace pureLegsCore;

		onDispose();

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
	 * Sends message for other framework actors to react to.
	 * @param    type    type of the message. (Commands and handle functions must be mapped to type to be triggered.)
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
		// clean up logging the actioDebugConfign
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendMessage(_moduleName, this, type, params, false));
		}
	}

	//----------------------------------
	//     Debug
	//----------------------------------

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
	//   INTERNAL. Getting module core classes.
	//----------------------------------

	/** INTERNAL, for extension development.
	 * gets messenger.
	 * @private */
	pureLegsCore function getMessenger():Messenger {
		return pureLegsCore::messenger;
	}

	/** INTERNAL, for extension development.
	 * gets proxyMap.
	 * @private */
	pureLegsCore function getProxyMap():ProxyMap {
		return proxyMap;
	}

	/** INTERNAL, for extension development.
	 * gets mediatorMap.
	 * @private */
	pureLegsCore function getMediatorMap():MediatorMap {
		return mediatorMap;
	}

	/** INTERNAL, for extension development.
	 * gets commandMap.
	 * @private */
	pureLegsCore function getCommandMap():CommandMap {
		return commandMap;
	}

	//----------------------------------
	//    INTERNAL, DEBUG ONLY. Extension handling.
	//----------------------------------

	/** @private */
	CONFIG::debug
	pureLegsCore var SUPPORTED_EXTENSIONS:Dictionary;

	/** @private */
	CONFIG::debug
	pureLegsCore function enableExtension(extensionId:int):void {
		use namespace pureLegsCore;

		if (SUPPORTED_EXTENSIONS == null) {
			SUPPORTED_EXTENSIONS = new Dictionary();
		}
		SUPPORTED_EXTENSIONS[extensionId] = true;
	}

	/** @private */
	CONFIG::debug
	pureLegsCore function listExtensions():String {
		use namespace pureLegsCore;

		var retVal:String = "";
		for (var key:Object in SUPPORTED_EXTENSIONS) {
			if (retVal) {
				retVal += ",";
			}
			retVal += ExtensionManager.getExtensionNameById(key as int);
		}
		return retVal;
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore const EXTENSION_CORE_ID:int = ExtensionManager.getExtensionIdByName(pureLegsCore::EXTENSION_CORE_NAME);

	/** @private */
	CONFIG::debug
	static pureLegsCore const EXTENSION_CORE_NAME:String = "CORE";

}
}