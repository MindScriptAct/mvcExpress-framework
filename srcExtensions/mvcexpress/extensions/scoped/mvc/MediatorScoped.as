// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.mvc {
import mvcexpress.MvcExpress;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.mediator.TraceMediator_sendScopeMessage;
import mvcexpress.extensions.scoped.core.ScopeManager;
import mvcexpress.extensions.scoped.modules.ModuleScoped;
import mvcexpress.mvc.Mediator;

use namespace pureLegsCore;

/**
 * Mediates single view object.                                                                                                                            </br>
 *  Main responsibility of mediator is to send message from framework  to view, and receive constants from view and send to framework.                        </br>
 *  Can get proxies injected.                                                                                                                                </br>
 *  Can send constants. (sends constants then user interacts with the view)                                                                                    </br>
 *  Can handle constants. (handles data change or other framework constants)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version scoped.1.0.beta2
 */
public class MediatorScoped extends Mediator {


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
			MvcExpress.debug(new TraceMediator_sendScopeMessage(moduleName, this, type, params, true));
		}
		//
		ScopeManager.sendScopeMessage(moduleName, scopeName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceMediator_sendScopeMessage(moduleName, this, type, params, false));
		}
	}


	//----------------------------------
	//     scope handling
	//----------------------------------

	/**
	 * Adds module to module communication handle function to be called then message of provided type is sent to provided scopeName.
	 * @param    scopeName    both sending and receiving modules must use same scope to make module to module communication.
	 * @param    type        type    message type for handle function to react to.
	 * @param    handler        function that will be called then needed message is sent. this function must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
	 */
	protected function addScopeHandler(scopeName:String, type:String, handler:Function):void {
		use namespace pureLegsCore;

		handlerVoRegistry[handlerVoRegistry.length] = ScopeManager.addScopeHandler(moduleName, scopeName, type, handler);
	}

	/**
	 * Removes module to module communication handle function from message of provided type, sent to provided scopeName.
	 * @param    scopeName    both sending and receiving modules must use same scope to make module to module communication.
	 * @param    type        type    message type for handle function to react to.
	 * @param    handler        function that will be called then needed message is sent. this function must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
	 */
	protected function removeScopeHandler(scopeName:String, type:String, handler:Function):void {
		use namespace pureLegsCore;

		ScopeManager.removeScopeHandler(scopeName, type, handler);
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