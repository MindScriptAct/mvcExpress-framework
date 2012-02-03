package org.mvcexpress.mvc {
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Classes to hold application data.
 * Can send messages.
 * @author rbanevicius
 */
public class Model {
	
	/** @private */
	pureLegsCore var messanger:Messenger;
	
	public function Model(){
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
	 * @private
	 */
	pureLegsCore function register():void {
		onRegister();
	}
	
	/**
	 * @private
	 */
	pureLegsCore function remove():void {
		onRemove();
	}
	
	/**
	 * Then model is map'ed with modelMap this function is called.
	 */
	protected function onRegister():void {
		// for override
	}
	
	/**
	 * Then model is unmap'ed with modelMap this function is called.
	 */
	protected function onRemove():void {
		// for override
	}

}
}