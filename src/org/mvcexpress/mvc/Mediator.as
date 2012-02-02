package org.mvcexpress.mvc {
import flash.utils.getQualifiedClassName;
import org.mvcexpress.base.interfaces.IMediatorMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.messenger.MsgVO;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Mediates single view object.
 *  It should only mediate(send message from/to them), not manage them.
 * @author rbanevicius
 */
public class Mediator {
	
	private var messageDataRegistry:Vector.<MsgVO> = new Vector.<MsgVO>();
	
	/** @private */
	pureLegsCore var messanger:Messenger;
	
	public var mediatorMap:IMediatorMap;
	
	public function Mediator() {
		// should stay empty.
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
		CONFIG::debug {
			if (handler.length < 1) {
				throw Error("Every message handler function needs at least one parameter. You are trying to add handler function from " + getQualifiedClassName(this));
			}
			messageDataRegistry.push(pureLegsCore::messanger.addHandler(type, handler, getQualifiedClassName(this)));
			return;
		}
		messageDataRegistry.push(pureLegsCore::messanger.addHandler(type, handler));
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
		for (var i:int = 0; i < messageDataRegistry.length; i++) {
			messageDataRegistry[i].disabled = true;
		}
		messageDataRegistry = null;
	}

}
}