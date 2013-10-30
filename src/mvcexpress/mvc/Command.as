// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.mvc {
import mvcexpress.MvcExpress;
import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.command.TraceCommand_sendMessage;
import mvcexpress.modules.ModuleCore;

use namespace pureLegsCore;

/**
 * Command, handles business logic of your application.                                                                                                    <br/>
 * Commands can get proxies injected and can send messages
 * <b><p>
 * It MUST contain custom execute(params:Object) function. Parameter can be typed as you wish.                                                             <br/>
 * It is best practice to use same type as you use in message, that triggers this command.                                                                 <br/>
 * If message does not send any parameter object - you still must have singe parameter that will get null value, for example: execute(blank:Object).
 * </p></b>
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
dynamic public class Command {

	/** Handles application Commands. */
	public var commandMap:CommandMap;

	/** Handles application Proxies. */
	public var proxyMap:ProxyMap;

	/** Handles application Mediators. */
	public var mediatorMap:MediatorMap;

	/** used internally for communication
	 * @private */
	pureLegsCore var messenger:Messenger;

	/** @private */
	pureLegsCore var messageType:String;

	/** flag to store if command is executed by commandMap.
	 * @private */
	pureLegsCore var isExecuting:Boolean; // = false;

	/** @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean; // = false;

	/** CONSTRUCTOR
	 * @private */
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
	 * Sends a message with optional params object
	 * @param    type    type of the message for Commands or Mediator's handle function to react to.
	 * @param    params    Object that will be passed to Command execute() function or to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommand_sendMessage(messenger.moduleName, this, type, params, true));
		}
		//
		messenger.send(type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommand_sendMessage(messenger.moduleName, this, type, params, false));
		}
	}


	//----------------------------------
	//     Getters
	//----------------------------------

	/**
	 * Type of message that executed this command. (If command is not executed by message it set to null.)
	 * @return        message type
	 */
	public function getMessageType():String {
		return pureLegsCore::messageType;
	}


	//----------------------------------
	//     Misc
	//----------------------------------

	// execute function is not meant to be overridden in mvcExpress.
	// You have to manually create execute() function in your commands, this gives possibility to set any type to params object.
	//public function execute(params:Object):void {
	//}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleCore.pureLegsCore::EXTENSION_CORE_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleCore.pureLegsCore::EXTENSION_CORE_NAME;

}
}
