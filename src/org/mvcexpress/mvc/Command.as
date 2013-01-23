// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import org.mvcexpress.MvcExpress;
import org.mvcexpress.core.CommandMap;
import org.mvcexpress.core.MediatorMap;
import org.mvcexpress.core.ModuleManager;
import org.mvcexpress.core.ProxyMap;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.command.TraceCommand_sendMessage;
import org.mvcexpress.core.traceObjects.command.TraceCommand_sendScopeMessage;

/**
 * Command, handles business logic of your application. 																																				</br>
 * If you need to change application state with one or more logical statement and/or you need more then one unrelated proxies injected to make a decision - most likely you need Command for the job.	</br>
 * Can get proxies injected.																																											</br>
 * Can send messages.
 * <b><p>
 * It MUST contain custom execute(params:Object) function. Parameter can be typed as you wish. 																											</br>
 * It is best practice to use same type as you use in message, that triggers this command.																												</br>
 * If message does not send any parameter object - you still must have singe parameter, for example: execute(blank:Object). This parameter will be null.													</br>
 * </p></b>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
dynamic public class Command {
	
	/** Handles application Commands. */
	public var commandMap:CommandMap;
	
	/** Handles application Proxies. */
	public var proxyMap:ProxyMap;
	
	/** Handles application Mediators. */
	public var mediatorMap:MediatorMap;
	
	// used internally for communication
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	//flag to store if command is executed by commandMap.
	/** @private */
	pureLegsCore var isExecuting:Boolean;// = false;
	
	/** @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean;// = false;
	
	/** CONSTRUCTOR */
	public function Command() {
		CONFIG::debug {
			use namespace pureLegsCore;
			if (!canConstruct) {
				throw Error("Command:" + this + " can be constructed only by framework. If you want to execute it - map it to message with commandMap.map() and send a message, or execute it directly with commandMap.execute()");
			}
		}
	}
	
	//----------------------------------
	//     MESSAGING
	//----------------------------------
	
	/**
	 * Sends a message with optional params object inside of current module.
	 * @param	type	type of the message for Commands or Mediator's handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function or to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		// log the action
		CONFIG::debug {
			var moduleName:String = messenger.moduleName;
			MvcExpress.debug(new TraceCommand_sendMessage(moduleName, this, type, params, true));
		}
		//
		messenger.send(type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommand_sendMessage(moduleName, this, type, params, false));
		}
	}
	
	/**
	 * Sends scoped module to module message, all modules that are listening to specified scopeName and message type will get it.
	 * @param	scopeName	both sending and receiving modules must use same scope to make module to module communication.
	 * @param	type		type of the message for Commands or Mediator's handle function to react to.
	 * @param	params		Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendScopeMessage(scopeName:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;
		// log the action
		CONFIG::debug {
			var moduleName:String = messenger.moduleName;
			MvcExpress.debug(new TraceCommand_sendScopeMessage(moduleName, this, type, params, true));
		}
		//
		ModuleManager.sendScopeMessage(scopeName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommand_sendScopeMessage(moduleName, this, type, params, false));
		}
	}

	//----------------------------------
	//     Misc
	//----------------------------------

	// execute function is not meant to be overridden in mvcExpress.
	// You have to manually create execute() function in your commands, this gives possibility to set any type to params object.
	//public function execute(params:Object):void {
	//}

}
}