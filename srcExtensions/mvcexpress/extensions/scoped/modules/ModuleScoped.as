// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.modules {
import mvcexpress.MvcExpress;
import mvcexpress.core.ExtensionManager;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.moduleBase.TraceModuleBase_sendScopeMessage;
import mvcexpress.extensions.scoped.core.CommandMapScoped;
import mvcexpress.extensions.scoped.core.ProxyMapScoped;
import mvcexpress.extensions.scoped.core.ScopeManager;
import mvcexpress.modules.ModuleCore;
import mvcexpress.utils.checkClassSuperclass;

/**
 * Core Module class, represents single application unit in mvcExpress framework.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 *
 * @version scoped.1.0.beta2
 */
public class ModuleScoped extends ModuleCore {

	/** Handles application Proxies. */
	protected var proxyMapScoped:ProxyMapScoped;

	/** Handles application Commands. */
	protected var commandMapScoped:CommandMapScoped;

	public function ModuleScoped(moduleName:String = null, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {

		CONFIG::debug {
			use namespace pureLegsCore;
			enableExtension(EXTENSION_SCOPED_ID);
		}

		if (!proxyMapClass) {
			proxyMapClass = ProxyMapScoped;
		}
		if (!commandMapClass) {
			commandMapClass = CommandMapScoped;
		}
		super(moduleName, mediatorMapClass, proxyMapClass, commandMapClass, messengerClass);

		CONFIG::debug {
			if (!checkClassSuperclass(proxyMapClass, "mvcexpress.core::ProxyMap")) {
				throw Error("proxyMapClass:" + proxyMapClass + " you are trying to use is not extended from 'mvcexpress.core::ProxyMap' class.");
			}
			if (!checkClassSuperclass(commandMapClass, "mvcexpress.core::CommandMap")) {
				throw Error("commandMapClass:" + commandMapClass + " you are trying to use is not extended from 'mvcexpress.core::CommandMap' class.");
			}
		}
		proxyMapScoped = proxyMap as ProxyMapScoped;
		commandMapScoped = commandMap as CommandMapScoped;
	}


	override public function disposeModule():void {
		ScopeManager.disposeModule(moduleName);
		super.disposeModule();
	}

	//----------------------------------
	//     SCOPED MESSAGING
	//----------------------------------

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
			MvcExpress.debug(new TraceModuleBase_sendScopeMessage(moduleName, this, type, params, true));
		}
		//
		ScopeManager.sendScopeMessage(moduleName, scopeName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendScopeMessage(moduleName, this, type, params, false));
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

		ScopeManager.registerScope(moduleName, scopeName, messageSending, messageReceiving, proxieMapping);
	}

	/**
	 * Unregisters scope name.
	 * Then scope is not registered module to module communication via scope and mapping proxies to scope becomes not possible.
	 * @param    scopeName            Name of the scope.
	 */
	protected function unregisterScope(scopeName:String):void {
		use namespace pureLegsCore;

		ScopeManager.unregisterScope(moduleName, scopeName);
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static pureLegsCore const EXTENSION_SCOPED_ID:int = ExtensionManager.getExtensionIdByName(pureLegsCore::EXTENSION_SCOPED_NAME);

	CONFIG::debug
	static pureLegsCore const EXTENSION_SCOPED_NAME:String = "scoped";

}
}