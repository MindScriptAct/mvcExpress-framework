// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.mvc {
import mvcexpress.MvcExpress;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.command.TraceCommand_sendScopeMessage;
import mvcexpress.extensions.scoped.core.ScopeManager;
import mvcexpress.extensions.scoped.modules.ModuleScoped;
import mvcexpress.mvc.*;

/**
 * Command that is automatically pooled.
 * All PooledCommand's are automatically pooled after execution for later reuse(except then they are locked)
 * You can lock() command to prevent it from being pooled after execute, locked commands are pooled after you unlock() it.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version scoped.1.0.beta2
 */
public class PooledCommandScoped extends PooledCommand {

	//----------------------------------
	//     MESSAGING
	//----------------------------------

	/**
	 * Sends scoped module to module message, all modules that are listening to specified scopeName and message type will get it.
	 * @param    scopeName    both sending and receiving modules must use same scope to make module to module communication.
	 * @param    type        type of the message for Commands or Mediator's handle function to react to.
	 * @param    params        Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendScopeMessage(scopeName:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommand_sendScopeMessage(messenger.moduleName, this, type, params, true));
		}
		//
		ScopeManager.sendScopeMessage(messenger.moduleName, scopeName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommand_sendScopeMessage(messenger.moduleName, this, type, params, false));
		}
	}

	/**
	 * Registers scope name.
	 * If scope name is not registered - module to module communication via scope and mapping proxies to scope is not possible.
	 * What features module can use with that scope is defined by parameters.
	 * @param    scopeName            Name of the scope.
	 * @param    messageSending        Modules can send constants to this scope.
	 * @param    messageReceiving    Modules can receive and handle constants from this scope.(or map commands to scoped constants);
	 * @param    proxieMapping        Modules can map proxies to this scope.
	 */
	protected function registerScope(scopeName:String, messageSending:Boolean = true, messageReceiving:Boolean = true, proxieMapping:Boolean = false):void {
		use namespace pureLegsCore;

		ScopeManager.registerScope(messenger.moduleName, scopeName, messageSending, messageReceiving, proxieMapping);
	}

	/**
	 * Unregisters scope name.
	 * Then scope is not registered module to module communication via scope and mapping proxies to scope becomes not possible.
	 * @param    scopeName            Name of the scope.
	 */
	protected function unregisterScope(scopeName:String):void {
		use namespace pureLegsCore;

		ScopeManager.unregisterScope(messenger.moduleName, scopeName);
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleScoped.pureLegsCore::EXTENSION_SCOPED_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleScoped.pureLegsCore::EXTENSION_SCOPED_NAME;

}
}