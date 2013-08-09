// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.modules {
import mvcexpress.MvcExpress;
import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ModuleManager;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.moduleBase.TraceModuleBase_sendMessage;
import mvcexpress.core.traceObjects.moduleBase.TraceModuleBase_sendScopeMessage;
import mvcexpress.modules.ModuleCore;
import mvcexpress.utils.checkClassSuperclass;

/**
 * Core Module class, represents single application unit in mvcExpress framework.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleScoped extends ModuleCore {


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
		ModuleManager.sendScopeMessage(moduleName, scopeName, type, params);
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

		ModuleManager.registerScope(moduleName, scopeName, messageSending, messageReceiving, proxieMapping);
	}

	/**
	 * Unregisters scope name.
	 * Then scope is not registered module to module communication via scope and mapping proxies to scope becomes not possible.
	 * @param    scopeName            Name of the scope.
	 */
	protected function unregisterScope(scopeName:String):void {
		use namespace pureLegsCore;

		ModuleManager.unregisterScope(moduleName, scopeName);
	}



}
}