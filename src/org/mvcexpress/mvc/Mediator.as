// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import flash.utils.getQualifiedClassName;
import org.mvcexpress.base.interfaces.IMediatorMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.messenger.MsgVO;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Mediates single view object.
 *  It should only mediate(send message from/to them), not manage them.
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class Mediator {
	
	/** @private */
	pureLegsCore var messageDataRegistry:Vector.<MsgVO> = new Vector.<MsgVO>();
	
	/** @private */
	pureLegsCore var messanger:Messenger;
	
	/** @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean;	
	
	public var mediatorMap:IMediatorMap;
	
	public function Mediator() {
		CONFIG::debug {
			if (!pureLegsCore::canConstruct) {
				throw Error("Command "+this+" can be constructed only by framework. If you want to execute it - map it to message with commandMap.map(), or execute it dirrectly with commandMap.execute()")
			}
		}	
	}
	
	/**
	 * Then viewObject is mediated by this mediator - it is inited and then this function is called.
	 */
	public function onRegister():void {
		// for override
	}
	
	/**
	 * Then viewObject is unmediated by this mediator - this function is called and then mediator is deleted.
	 */
	public function onRemove():void {
		// for override
	}
	
	/**
	 * Sends a message with optional params object.
	 * @param	type	type of the message for Commands and handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		pureLegsCore::messanger.send(type, params);
	}
	
	
	/**
	 * adds handle function to be called then messege of provided type is sent.
	 * @param	type	message type for handle function to reoct to. 
	 * @param	handler	function that will be called then needed message is sent. this functino must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
	 */
	protected function addHandler(type:String, handler:Function):void {
		use namespace pureLegsCore;
		CONFIG::debug {
			if (handler.length < 1) {
				throw Error("Every message handler function needs at least one parameter. You are trying to add handler function from " + getQualifiedClassName(this));
			}
			messageDataRegistry.push(messanger.addHandler(type, handler, getQualifiedClassName(this)));
			return;
		}
		messageDataRegistry.push(messanger.addHandler(type, handler));
	}
	
	/**
	 * Removes handle function from messege of provided type.
	 * @param	type	message type that was set for handle function to react to. 
	 * @param	handler	function that was set to react to message.
	 */
	protected function removeHandler(type:String, handler:Function):void {
		pureLegsCore::messanger.removeHandler(type, handler);
	}
	
	
	/**
	 * framework funciton to remove all handle functions created by this mediator 
	 * @private
	 * */
	pureLegsCore function removeAllHandlers():void {
		use namespace pureLegsCore;
		for (var i:int = 0; i < messageDataRegistry.length; i++) {
			messageDataRegistry[i].disabled = true;
		}
		messageDataRegistry = null;
	}

}
}