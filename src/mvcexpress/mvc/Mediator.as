// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.mvc {
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import mvcexpress.MvcExpress;
import mvcexpress.core.interfaces.IMediatorMap;
import mvcexpress.core.interfaces.IProxyMap;
import mvcexpress.core.messenger.HandlerVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.mediator.TraceMediator_addHandler;
import mvcexpress.core.traceObjects.mediator.TraceMediator_sendMessage;
import mvcexpress.modules.ModuleCore;

use namespace pureLegsCore;

/**
 * Mediates single view object.
 *  Main responsibility of mediator is to send messages from framework to view, and receive events from view and send them to framework as messages.       <p>
 *  Can get proxies injected.
 *  Can send message strings. (then user interacts with the view, or to inform about view state changes, like animation end)
 *  Can handle message strings. (handles data change or other framework constants)
 *  Can handle view events.                                                                                                                               </p>
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class Mediator {

	/** name of module this mediator is working in.
	 * @private */
	pureLegsCore var moduleName:String

	/**
	 * Interface to work with proxies.
	 */
	public var proxyMap:IProxyMap;

	/**
	 * Handles application mediators.
	 */
	public var mediatorMap:IMediatorMap;

	/** used internally for communications
	 * @private */
	pureLegsCore var messenger:Messenger;

	/** Shows if proxy is ready. Read only.
	 * @private */
	pureLegsCore var isReady:Boolean; // = false;

	/** amount of pending injections.
	 * @private */
	pureLegsCore var pendingInjections:int; // = 0;

	/** all added message handlers.
	 * @private */
	pureLegsCore var handlerVoRegistry:Vector.<HandlerVO> = new Vector.<HandlerVO>();

	/** contains dictionary of added event listeners, stored by event listening function as a key. For event useCapture = false
	 * @private */
	pureLegsCore var eventListenerRegistry:Dictionary = new Dictionary(); //* or Dictionary by Function */

	/** contains array of added event listeners, stored by event listening function as a key. For event useCapture = true
	 * @private */
	pureLegsCore var eventListenerCaptureRegistry:Dictionary = new Dictionary(); //* or Dictionary by Function */

	/** Allows Mediator to be constructed. (removed from release build to save some performance.)
	 * @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean; // = false;

	/** CONSTRUCTOR
	 * @private */
	public function Mediator() {
		CONFIG::debug {
			use namespace pureLegsCore;

			if (!canConstruct) {
				throw Error("Mediator:" + this + " can be constructed only by framework. If you want to use it - map it to view object class with 'mediatorMap.map()', and then mediate instance of the view object with 'mediatorMap.mediate()'.");
			}
		}
	}


	//----------------------------------
	//     Life cycle functions
	//----------------------------------

	/**
	 * Then viewObject is mediated by this mediator - it is inited first and then this function is called.
	 */
	protected function onRegister():void {
		// for override
	}

	/**
	 * Then viewObject is unmediated by this mediator - this function is called first and then mediator is removed.
	 */
	protected function onRemove():void {
		// for override
	}

	//----------------------------------
	//     MESSAGING
	//----------------------------------

	/**
	 * Sends a message with optional params object inside of current module.
	 * @param    type    type of the message for Commands or Mediator's handle function to react to.
	 * @param    params    Object that will be passed to Command execute() function or to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceMediator_sendMessage(moduleName, this, type, params, true));
		}
		//
		messenger.send(type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceMediator_sendMessage(moduleName, this, type, params, false));
		}
	}

	//----------------------------------
	//     message handlers
	//----------------------------------

	/**
	 * Adds handle function to be called then message of given type is sent.
	 * @param    type    message type for handle function to react to.
	 * @param    handler    function that will be called then needed message is sent. this function must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
	 */
	protected function addHandler(type:String, handler:Function):void {
		use namespace pureLegsCore;

		CONFIG::debug {
			if (handler.length < 1) {
				throw Error("Every message handler function needs at least one parameter. You are trying to add handler function from " + getQualifiedClassName(this) + " for message type:" + type);
			}
			if (!Boolean(type) || type == "null" || type == "undefined") {
				throw Error("Message type:[" + type + "] can not be empty or 'null'.(You are trying to add message handler in: " + this + ")");
			}
			MvcExpress.debug(new TraceMediator_addHandler(moduleName, this, type, handler));

			handlerVoRegistry[handlerVoRegistry.length] = messenger.addHandler(type, handler, getQualifiedClassName(this));
			return;
		}
		handlerVoRegistry[handlerVoRegistry.length] = messenger.addHandler(type, handler);
	}

	/**
	 * Removes handle function from message of given type.
	 * Then Mediator is removed(unmediated) all message handlers are automatically removed by framework.
	 * @param    type    message type that was set for handle function to react to.
	 * @param    handler    function that was set to react to message.
	 */
	protected function removeHandler(type:String, handler:Function):void {
		use namespace pureLegsCore;

		messenger.removeHandler(type, handler);
	}

	/**
	 * Remove all handle functions created by this mediator, internal module handlers AND scoped handlers.
	 * Automatically called then mediator is removed(unmediated) by framework.
	 * (You don't have to put it in mediators onRemove() function.)
	 */
	protected function removeAllHandlers():void {
		use namespace pureLegsCore;

		while (handlerVoRegistry.length) {
			var handler:HandlerVO = handlerVoRegistry.pop();
			handler.handler = null;
		}
	}


	//----------------------------------
	//     event handling
	//----------------------------------

	/**
	 * Registers an event listener object with viewObject, so that the listener is executed then event is dispatched.
	 * @param    viewObject    view object that can dispatch events.
	 * @param    type    The type of event.
	 * @param    listener    The listener function that processes the event. This function must accept an event object
	 *   as its only parameter and must return nothing, as this example shows:
	 *   function(event:Event):void
	 *   The function can have any name.
	 * @param    useCapture    Determines whether the listener works in the capture phase or the target and bubbling phases.
	 * @param    priority    The priority level of the event listener. Priorities are designated by a 32-bit integer. The higher the number, the higher the priority.
	 *        If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.
	 * @param    useWeakReference    Determines whether the reference to the listener is strong or weak.
	 *        A strong reference (the default) prevents your listener from being garbage-collected. A weak reference does not.
	 */
	protected function addListener(viewObject:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
		if (useCapture) {
			if (!eventListenerCaptureRegistry[listener]) {
				eventListenerCaptureRegistry[listener] = new Dictionary();
			}
			if (!eventListenerCaptureRegistry[listener][type]) {
				eventListenerCaptureRegistry[listener][type] = viewObject;
				viewObject.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		} else {
			if (!eventListenerRegistry[listener]) {
				eventListenerRegistry[listener] = new Dictionary();
			}
			if (!eventListenerRegistry[listener][type]) {
				eventListenerRegistry[listener][type] = viewObject;
				viewObject.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
	}

	/**
	 * Removes an event listener from the viewObject.
	 * Then Mediator is removed(unmediated) all event handlers added with addListener() function will be automatically removed by framework.
	 * @param    viewObject    view object that can dispatch events.
	 * @param    type        The type of event.
	 * @param    listener    The listener object to remove.
	 * @param    useCapture    Specifies whether the listener was registered for the capture phase or the target and bubbling phases.
	 */
	protected function removeListener(viewObject:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void {
		viewObject.removeEventListener(type, listener, useCapture);

		if (useCapture) {
			if (eventListenerCaptureRegistry[listener]) {
				if (eventListenerCaptureRegistry[listener][type]) {
					if (eventListenerCaptureRegistry[listener][type] == viewObject) {
						delete eventListenerCaptureRegistry[listener][type];
					}
				}
			}
		} else {
			if (eventListenerRegistry[listener]) {
				if (eventListenerRegistry[listener][type]) {
					if (eventListenerRegistry[listener][type] == viewObject) {
						delete eventListenerRegistry[listener][type];
					}
				}
			}
		}
	}

	/**
	 * Removes all listeners created by mediators addEventListener() function.
	 * WARNING: It will NOT remove events that was added normally with viewObject.addEventListener() function.
	 * Automatically called then mediator is removed(unmediated) by framework.
	 * (You don't have to put it in mediators onRemove() function.)
	 */
	protected function removeAllListeners():void {
		for (var listener:Object in eventListenerCaptureRegistry) {
			var eventTypes:Dictionary = eventListenerCaptureRegistry[viewObject];
			for (var type:String in eventTypes) {
				var viewObject:IEventDispatcher = eventTypes[type];
				viewObject.removeEventListener(type, listener as Function, true);
			}
		}
		for (listener in eventListenerRegistry) {
			eventTypes = eventListenerRegistry[viewObject];
			for (type in eventTypes) {
				viewObject = eventTypes[type];
				viewObject.removeEventListener(type, listener as Function, false);
			}
		}
	}

	//----------------------------------
	//     INTERNAL
	//----------------------------------

	/**
	 * marks mediator as ready and calls onRegister()
	 * Executed automatically BEFORE mediator is created. (with proxyMap.mediate(...))
	 * @private */
	pureLegsCore function register():void {
		isReady = true;
		onRegister();
	}

	/**
	 * framework function to dispose this mediator.
	 * Executed automatically AFTER mediator is removed(unmediated). (after mediatorMap.unmediate(...), or module dispose.)
	 * It:
	 * - remove all handle functions created by this mediator
	 * - remove all event listeners created by internal addListener() function
	 * - sets internals to null
	 * @private
	 */
	pureLegsCore function remove():void {
		use namespace pureLegsCore;

		onRemove();
		removeAllHandlers();
		removeAllListeners();
		handlerVoRegistry = null;
		eventListenerRegistry = null;
		messenger = null;
		mediatorMap = null;
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleCore.EXTENSION_CORE_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleCore.EXTENSION_CORE_NAME;


}
}