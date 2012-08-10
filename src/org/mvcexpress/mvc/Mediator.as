// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.core.interfaces.IMediatorMap;
import org.mvcexpress.core.interfaces.IProxyMap;
import org.mvcexpress.core.messenger.HandlerVO;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.TraceMediator_addHandler;
import org.mvcexpress.core.traceObjects.TraceMediator_sendMessage;
import org.mvcexpress.MvcExpress;

/**
 * Mediates single view object. 																</br>
 *  It should only mediate(send message from/to them), not manage them. 						</br>
 *  Can send messages. (Usually sends messages then user interacts with view)					</br>
 *  Can handle messages. (Usually listens for data change messages, or other view objects)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Mediator {
	
	/**
	 * Interface to work with proxies.
	 */
	public var proxyMap:IProxyMap;
	
	/**
	 * Handles application mediators.
	 */
	public var mediatorMap:IMediatorMap;
	
	// Shows if proxy is ready. Read only.
	private var _isReady:Boolean = false;
	
	// for message comunication
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	// Allows Mediator to be constructed. (removed from release build to save some performance.)
	/** @private */
	pureLegsCore var pendingInjections:int = 0;
	
	/** @private */
	pureLegsCore var messageDataRegistry:Vector.<HandlerVO> = new Vector.<HandlerVO>();
	
	/** contains dictionary of added event listeners, stored by event listening function as a key. For event useCapture = false*/
	private var eventListenerRegistry:Dictionary = new Dictionary(); /* or Dictionary by Function */
	
	/** contains array of added event listeners, stored by event listening function as a key. For event useCapture = true*/
	private var eventListenerCaptureRegistry:Dictionary = new Dictionary(); /* or Dictionary by Function */
	
	/** @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean;
	
	/** CONSTRUCTOR */
	public function Mediator() {
		CONFIG::debug {
			use namespace pureLegsCore
			if (!canConstruct) {
				throw Error("Mediator:" + this + " can be constructed only by framework. If you want to use it - map it to view object class with 'mediatorMap.map()', and then mediate instance of the view object with 'mediatorMap.mediate()'.")
			}
		}
	}
	
	/**
	 * sets proxyMap interface.
	 * @param	iProxyMap
	 * @private
	 */
	pureLegsCore function setProxyMap(iProxyMap:IProxyMap):void {
		this.proxyMap = iProxyMap;
	}
	
	/**
	 * Indicates if mediator is ready for usage. (all dependencies are injected.)
	 */
	protected function get isReady():Boolean {
		return _isReady;
	}
	
	//----------------------------------
	//     mediator start-up and tier-down life cycle
	//----------------------------------
	
	/**
	 * marks mediator as ready and calls onRegister()
	 * Executed automatically BEFORE mediator is created. (with proxyMap.mediate(...))
	 * @private */
	pureLegsCore function register():void {
		_isReady = true;
		onRegister();
	}
	
	/**
	 * Then viewObject is mediated by this mediator - it is inited first and then this function is called.
	 */
	public function onRegister():void {
		// for override
	}
	
	/**
	 * Then viewObject is unmediated by this mediator - this function is called first and then mediator is removed.
	 */
	public function onRemove():void {
		// for override
	}
	
	/**
	 * framework function to dispose this mediator. 																			<br>
	 * Executed automatically AFTER mediator is removed. (with proxyMap.unmediate(...))											<br>
	 * It:																														<br>
	 * - remove all handle functions created by this mediator																	<br>
	 * - remove all event listeners created by internal addEventListener() function of this mediator							<br>
	 * - set internals to null																									<br>
	 * @private
	 */
	pureLegsCore function disposeThisMediator():void {
		use namespace pureLegsCore;
		removeAllHandlers();
		removeAllListeners();
		messageDataRegistry = null;
		eventListenerRegistry = null;
		messenger = null;
		mediatorMap = null;
	}
	
	//----------------------------------
	//     send messages
	//----------------------------------	
	
	/**
	 * Sends a message with optional params object.
	 * @param	type	type of the message for Commands and handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		// log the action
		CONFIG::debug {
			if (MvcExpress.loggerFunction != null) {
				MvcExpress.loggerFunction(new TraceMediator_sendMessage("Mediator.sendMessage", messenger.moduleName, this, type, params));
			}
		}
		//
		messenger.send(type, params);
		//
		// clean up loging the action
		CONFIG::debug {
			if (MvcExpress.loggerFunction != null) {
				MvcExpress.loggerFunction(new TraceMediator_sendMessage("Mediator.sendMessage.CLEAN", messenger.moduleName, this, type, params));
			}
		}
	}
	
	/**
	 * Sends message to all existing modules.
	 * @param	type				message type to find needed handlers
	 * @param	params				parameter object that will be sent to all handler and execute functions as single parameter.
	 */
	protected function sendMessageToAll(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		messenger.sendToAll(type, params);
	}
	
	//----------------------------------
	//     message handlers
	//----------------------------------
	
	/**
	 * adds handle function to be called then message of provided type is sent.
	 * @param	type	message type for handle function to react to.
	 * @param	handler	function that will be called then needed message is sent. this function must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
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
			if (MvcExpress.loggerFunction != null) {
				MvcExpress.loggerFunction(new TraceMediator_addHandler("Mediator.addHandler", messenger.moduleName, this, type, handler));
			}
			messageDataRegistry.push(messenger.addHandler(type, handler, getQualifiedClassName(this)));
			return;
		}
		messageDataRegistry.push(messenger.addHandler(type, handler));
	}
	
	/**
	 * Removes handle function from message of provided type.
	 * @param	type	message type that was set for handle function to react to.
	 * @param	handler	function that was set to react to message.
	 */
	protected function removeHandler(type:String, handler:Function):void {
		use namespace pureLegsCore;
		messenger.removeHandler(type, handler);
	}
	
	/**
	 * Remove all handle functions created by this mediator. Automatically called with unmediate().
	 * (but don't forget to remove your event handler manualy...)
	 */
	protected function removeAllHandlers():void {
		use namespace pureLegsCore;
		while (messageDataRegistry.length) {
			messageDataRegistry.pop().handler = null;
		}
	}
	
	//----------------------------------
	//     event handling
	//----------------------------------
	
	/**
	 * Registers an event listener object with viewObject, so that the listener receives notification of an event.
	 * @param	viewObject	view object that can dispatch events.
	 * @param	type	The type of event.
	 * @param	listener	The listener function that processes the event. This function must accept an event object
	 *   as its only parameter and must return nothing, as this example shows:
	 *   function(evt:Event):void
	 *   The function can have any name.
	 * @param	useCapture	Determines whether the listener works in the capture phase or the target and bubbling phases.
	 * @param	priority	The priority level of the event listener. Priorities are designated by a 32-bit integer. The higher the number, the higher the priority.
	 *		If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.
	 * @param	useWeakReference	Determines whether the reference to the listener is strong or weak.
	 *		A strong reference (the default) prevents your listener from being garbage-collected. A weak reference does not.
	 */
	protected function addListener(viewObject:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void {
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
	 * Removes a listener from the viewObject.
	 * @param	viewObject	view object that can dispatch events.
	 * @param	type		The type of event.
	 * @param	listener	The listener object to remove.
	 * @param	useCapture	Specifies whether the listener was registered for the capture phase or the target and bubbling phases.
	 */
	protected function removeListener(viewObject:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void {
		viewObject.removeEventListener(type, listener, useCapture);
		
		if (useCapture) {
			if (eventListenerCaptureRegistry[listener]) {
				if (eventListenerCaptureRegistry[listener][type]) {
					if (eventListenerCaptureRegistry[listener][type] == viewObject) {
						delete eventListenerCaptureRegistry[listener][type]
					}
				}
			}
		} else {
			if (eventListenerRegistry[listener]) {
				if (eventListenerRegistry[listener][type]) {
					if (eventListenerRegistry[listener][type] == viewObject) {
						delete eventListenerRegistry[listener][type]
					}
				}
			}
		}
	}
	
	/**
	 * Removes all listeners created by mediators addEventListener() function.
	 * Automatically called then mediator is unmediated.
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

}
}