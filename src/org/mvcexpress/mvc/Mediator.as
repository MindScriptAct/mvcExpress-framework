// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import flash.utils.getQualifiedClassName;
import org.mvcexpress.base.interfaces.IMediatorMap;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.messenger.HandlerVO;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Mediates single view object. 																</br>
 *  It should only mediate(send message from/to them), not manage them. 						</br>
 *  Can send messages. (Usually sends messages then user interacts with view)					</br>
 *  Can handle messages. (Usually listens for data change messages, or other view objects)
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class Mediator {
	
	/** @private */
	pureLegsCore var messageDataRegistry:Vector.<HandlerVO> = new Vector.<HandlerVO>();
	
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	/** @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean;
	
	// Allows Mediator to be constructed. (removed from release build to save some performance.)
	/** @private */
	pureLegsCore var pendingInjections:int = 0;
	
	private var _isReady:Boolean = false;
	
	/**
	 * Handles application mediators.
	 */
	public var mediatorMap:IMediatorMap;
	
	/* CONSTRUCTOR */
	public function Mediator() {
		CONFIG::debug {
			use namespace pureLegsCore
			if (!canConstruct) {
				throw Error("Mediator:" + this + " can be constructed only by framework. If you want to use it - map it to view object class with 'mediatorMap.map()', and then mediate instance of the view object with 'mediatorMap.mediate()'.")
			}
		}
	}
	
	// marks mediator as ready and calls onRegister()
	/** @private */
	pureLegsCore function register():void {
		_isReady = true;
		onRegister();
	}
	
	/**
	 * Then viewObject is mediated by this mediator - it is innited first and then this function is called.
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
	 * Sends a message with optional params object.
	 * @param	type	type of the message for Commands and handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function and to handle functions.
	 * @param	targetModuleNames	array of module names as strings, by default [MessageTarget.SELF] is used.<\br>
	 * 									To target all existing modules use : [MessageTarget.ALL]
	 */
	protected function sendMessage(type:String, params:Object = null, targetModuleNames:Array = null):void {
		use namespace pureLegsCore;
		messenger.send(type, params, targetModuleNames);
	}
	
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
			messageDataRegistry.pop().disabled = true;
		}
	}
	
	/**
	 * framework function to remove all handle functions created by this mediator
	 * @private
	 */
	pureLegsCore function disposeThisMediator():void {
		use namespace pureLegsCore;
		removeAllHandlers();
		messageDataRegistry = null;
		messenger = null;
		mediatorMap = null;
	}
	
	/**
	 * Indicates if mediator is ready for usage. (all dependencies are injected.)
	 */
	protected function get isReady():Boolean {
		return _isReady;
	}
}
}