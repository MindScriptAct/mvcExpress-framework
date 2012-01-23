package org.pureLegs.mvc {
import org.pureLegs.messenger.IMessageSender;
import org.pureLegs.namespace.pureLegsCore;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Model {
	
	pureLegsCore var messanger:IMessageSender;
	
	public function Model(){
	
	}
	
	protected function sendMessage(type:String, body:Object = null):void {
		pureLegsCore::messanger.send(type, body);
	}

}
}