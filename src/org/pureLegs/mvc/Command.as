package org.pureLegs.mvc {
import org.pureLegs.core.CommandMap;
import org.pureLegs.core.MediatorMap;
import org.pureLegs.core.ModelMap;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.namespace.pureLegsCore;

/**
 * For commands that handles buisness logic of your application.
 *  It must cantain execute(params:Object) function. parameter object can be typed as you wish.
 * @author rbanevicius
 */
dynamic public class Command {
	
	public var commandMap:CommandMap;
	public var mediatorMap:MediatorMap;
	public var modelMap:ModelMap;
	
	pureLegsCore var messenger:Messenger;
	
	/**
	 * Sends a message with optional params object.
	 * @param	type	type of the message for Commands and handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		pureLegsCore::messenger.send(type, params);
	}	

}
}