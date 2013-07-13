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

/**
 * Core Module class. Used if you don't want your module be display object.
 * Usually it is good idea to create your main(shell) module from ModuleCore.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleCore {

	protected var _moduleName:String;

	/** for communication. */
	protected var _messenger:Messenger;


	/** Handles application Proxies. */
	protected var proxyMap:ProxyMap;
	/** Handles application Mediators. */
	protected var mediatorMap:MediatorMap;
	/** Handles application Commands. */
	protected var commandMap:CommandMap;


	/**
	 * CONSTRUCTOR
	 * @param    moduleName    module name that is used for referencing a module. (if not provided - unique name will be generated.)
	 * @param    autoInit    if set to false framework is not initialized for this module. If you want to use framework features you will have to manually init() it first.
	 */
	public function ModuleCore(moduleName:String = null, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {
		use namespace pureLegsCore;

		if (!mediatorMapClass) {
			mediatorMapClass = MediatorMap;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		if (!proxyMapClass) {
			proxyMapClass = ProxyMap;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		if (!commandMapClass) {
			commandMapClass = CommandMap;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		if (!messengerClass) {
			messengerClass = Messenger;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}

		//
		_moduleName = ModuleManager.registerModule(moduleName, this);
		//

		Messenger.allowInstantiation = true;
		_messenger = new messengerClass(_moduleName);
		Messenger.allowInstantiation = false;

		// proxyMap
		proxyMap = new proxyMapClass(_moduleName, _messenger);

		// mediatorMap
		mediatorMap = new mediatorMapClass(_moduleName, _messenger, proxyMap);

		// commandMap
		commandMap = new commandMapClass(_moduleName, _messenger, proxyMap, mediatorMap);
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
		if (commandMap) {
			commandMap.dispose();
			commandMap = null;
		}
		if (mediatorMap) {
			mediatorMap.dispose();
			mediatorMap = null;
		}
		if (proxyMap) {
			proxyMap.dispose();
			proxyMap = null;
		}
		_messenger = null;
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
		_messenger.send(type, params);
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
	 * @param    messageSending        Modules can send messages to this scope.
	 * @param    messageReceiving    Modules can receive and handle messages from this scope.(or map commands to scoped messages);
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
		return _messenger.listMappings(commandMap);
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
	//     Internal
	//----------------------------------

	/**
	 * framework access to module messenger
	 * @private
	 */
	pureLegsCore function get messenger():Messenger {
		return _messenger;
	}


}
}