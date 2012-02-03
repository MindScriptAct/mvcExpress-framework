package com.mindScriptAct.modularSample.modules.console.model {
import com.adobe.ac.util.service.ILocalConnection;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleDataMsg;
import org.mvcexpress.mvc.Model;

/**
 * COMMENT
 * @author rbanevicius
 */
public class ConsoleLogModel extends Model {
	
	private var messageList:Vector.<String> = new Vector.<String>();
	
	public function ConsoleLogModel() {
	
	}
	
	public function pushMessage(messageText:String):void {
		messageList.push(messageText);
		sendMessage(ConsoleDataMsg.MESSAGE_ADDED, messageText);
	}

}
}