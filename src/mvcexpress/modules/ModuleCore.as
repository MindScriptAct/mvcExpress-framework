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
 * Core Module class, represents single application unit in mvcExpress framework.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleCore {

	// name of the module
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
	 * @param moduleName        module name that is used for referencing a module. (if not provided - unique name will be generated automatically.)
	 */
	public function ModuleCore(moduleName:String = null) {
		use namespace pureLegsCore;

		// register module with ModuleManager. (And get module name if it is not provided.)
		_moduleName = ModuleManager.registerModule(moduleName, this);

		// create and initialize module messenger.
		use namespace pureLegsCore;

		Messenger.allowInstantiation = true;
		initializeMessenger();
		Messenger.allowInstantiation = false;

		_messenger.initialize(_moduleName);

		// create commandMap
		initializeController();

		// create and initialize proxyMap
		initializeModel();
		proxyMap.initialize(_moduleName, _messenger, commandMap);

		// create and initialize mediatorMap
		initializeView();
		mediatorMap.initialize(_moduleName, _messenger, proxyMap);

		// initialize commandMap
		commandMap.initialize(_moduleName, _messenger, proxyMap, mediatorMap);

		onInit();
	}

	/**
	 * Initialize Messenger.
	 *
	 * <P>
	 * Called automatically by the constructor.
	 * Override this method if you wish to initialize Messenger subclass.
	 * </P>
	 */
	protected function initializeMessenger():void {
		_messenger = new Messenger();
	}

	/**
	 * Initialize CommandMap.
	 *
	 * <P>
	 * Called automatically by the constructor.
	 * Override this method if you wish to initialize CommandMap subclass.                                    <br>
	 * Or if you want to map your Commands in this function, (don't forget to call <code>super.initializeController()</code>
	 * </P>
	 */
	protected function initializeController():void {
		commandMap = new CommandMap();
	}

	/**
	 * Initialize ProxyMap.
	 *
	 * <P>
	 * Called automatically by the constructor.
	 * Override this method if you wish to initialize ProxyMap subclass.                                    <br>
	 * Or if you want to map your Proxies in this function, (don't forget to call <code>super.initializeModel()</code>
	 * </P>
	 */
	protected function initializeModel():void {
		proxyMap = new ProxyMap();
	}


	/**
	 * Initialize MediatorMap.
	 *
	 * <P>
	 * Called automatically by the constructor.
	 * Override this method if you wish to initialize MediatorMap subclass.                                    <br>
	 * Or if you want to map your wiew classes to Mediator classes in this function, (don't forget to call <code>super.initializeView()</code>
	 * </P>
	 */
	protected function initializeView():void {
		mediatorMap = new MediatorMap();
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

		_messenger.dispose();
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