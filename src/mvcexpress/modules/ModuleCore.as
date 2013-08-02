// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.modules {
import mvcexpress.MvcExpress;
import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ModuleManager;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.moduleBase.TraceModuleBase_sendMessage;
import mvcexpress.core.traceObjects.moduleBase.TraceModuleBase_sendScopeMessage;
import mvcexpress.utils.checkClassSuperclass;

/**
 * Core Module class, represents single application unit in mvcExpress framework.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
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
	 * @param mediatorMapClass  OPTIONAL class to change default MediatorMap class. (For advanced users only.)
	 * @param proxyMapClass     OPTIONAL class to change default ProxyMap class. (For advanced users only.)
	 * @param commandMapClass   OPTIONAL class to change default CommandMap class. (For advanced users only.)
	 * @param messengerClass    OPTIONAL class to change default Messenger class. (For advanced users only.)
	 */
	public function ModuleCore(moduleName:String = null, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {
		use namespace pureLegsCore;

		if (!mediatorMapClass) {
			mediatorMapClass = MediatorMap;
		} else {
			CONFIG::debug {
				if (!checkClassSuperclass(mediatorMapClass, "mvcexpress.core::MediatorMap", true)) {
					throw Error("ModuleCore can use only mediatorMapClass that extends MediatorMap. (" + mediatorMapClass + " will not work)");
				}
			}
		}
		if (!proxyMapClass) {
			proxyMapClass = ProxyMap;
		} else {
			CONFIG::debug {
				if (!checkClassSuperclass(proxyMapClass, "mvcexpress.core::ProxyMap", true)) {
					throw Error("ModuleCore can use only proxyMapClass that extends ProxyMap. (" + proxyMapClass + " will not work)");
				}
			}
		}
		if (!commandMapClass) {
			commandMapClass = CommandMap;
		} else {
			CONFIG::debug {
				if (!checkClassSuperclass(commandMapClass, "mvcexpress.core::CommandMap", true)) {
					throw Error("ModuleCore can use only commandMapClass that extends CommandMap. (" + commandMapClass + " will not work)");
				}
			}
		}
		if (!messengerClass) {
			messengerClass = Messenger;
		} else {
			CONFIG::debug {
				if (!checkClassSuperclass(messengerClass, "mvcexpress.core.messenger::Messenger", true)) {
				throw Error("ModuleCore can use only messengerClass that extends Messenger. (" + messengerClass + " will not work)");
				}
			}
		}

		// register module with ModuleManager. (And get module name if it is not provided.)
		_moduleName = ModuleManager.registerModule(moduleName, this);

		// create module messenger.
		Messenger.allowInstantiation = true;
		messenger = new messengerClass(_moduleName);
		Messenger.allowInstantiation = false;

		// create module proxyMap
		proxyMap = new proxyMapClass(_moduleName, messenger);

		// create module mediatorMap
		mediatorMap = new mediatorMapClass(_moduleName, messenger, proxyMap);

		// create module commandMap
		commandMap = new commandMapClass(_moduleName, messenger, proxyMap, mediatorMap);
		proxyMap.setCommandMap(commandMap);

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
		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;

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

	/**
	 * Sends scoped module to module message, all modules that are listening to specified scopeName and message type will get it.
	 * @param    scopeName    both sending and receiving modules must use same scope to make module to module communication.
	 * @param    type        type of the message for Commands or Mediator's handle function to react to.
	 * @param    params        Object that will be passed to Command execute() function or to handle functions.
	 */
	public function sendScopeMessage(scopeName:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendScopeMessage(_moduleName, this, type, params, true));
		}
		//
		ModuleManager.sendScopeMessage(_moduleName, scopeName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendScopeMessage(_moduleName, this, type, params, false));
		}
	}

	/**
	 * Registers scope name.
	 * If scope name is not registered - module to module communication via scope and mapping proxies to scope is not possible.
	 * What features module can use with that scope is defined by parameters.
	 * @param    scopeName            Name of the scope.
	 * @param    messageSending        Modules can send constants to this scope.
	 * @param    messageReceiving    Modules can receive and handle constants from this scope.(or map commands to scoped constants);
	 * @param    proxieMap            Modules can map proxies to this scope.
	 */
	protected function registerScope(scopeName:String, messageSending:Boolean = true, messageReceiving:Boolean = true, proxieMapping:Boolean = false):void {
		use namespace pureLegsCore;

		ModuleManager.registerScope(_moduleName, scopeName, messageSending, messageReceiving, proxieMapping);
	}

	/**
	 * Unregisters scope name.
	 * Then scope is not registered module to module communication via scope and mapping proxies to scope becomes not possible.
	 * @param    scopeName            Name of the scope.
	 */
	protected function unregisterScope(scopeName:String):void {
		use namespace pureLegsCore;

		ModuleManager.unregisterScope(_moduleName, scopeName);
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


}
}