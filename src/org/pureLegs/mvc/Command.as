package org.pureLegs.mvc {
import org.pureLegs.core.CommandMap;
import org.pureLegs.core.MediatorMap;
import org.pureLegs.core.ModelMap;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.namespace.pureLegsCore;

/**
 * COMMENT
 * @author rbanevicius
 */
dynamic public class Command {
	
	public var commandMap:CommandMap;
	public var mediatorMap:MediatorMap;
	public var modelMap:ModelMap;
	
	pureLegsCore var messenger:Messenger;
	
	protected function sendMessage(type:String, body:Object = null):void {
		pureLegsCore::messenger.send(type, body);
	}	

}
}