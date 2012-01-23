package org.pureLegs.mvc {
import org.pureLegs.messenger.IMessageSender;
import org.pureLegs.namespace.pureLegsCore;

/**
 * Classes to hold application data.
 *  Can send mennages.
 * @author rbanevicius
 */
public class Model {
	
	pureLegsCore var messanger:IMessageSender;
	
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

}
}