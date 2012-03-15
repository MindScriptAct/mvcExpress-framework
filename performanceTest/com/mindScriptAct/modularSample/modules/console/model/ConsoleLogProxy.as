package com.mindScriptAct.modularSample.modules.console.model {
import com.adobe.ac.util.service.ILocalConnection;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleDataMsg;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ConsoleLogProxy extends Proxy {
	
	private var messageList:Vector.<String> = new Vector.<String>();
	
	public function ConsoleLogProxy() {
	
	}
	
	public function pushMessage(messageText:String):void {
		messageList.push(messageText);
		sendMessage(ConsoleDataMsg.MESSAGE_ADDED, messageText);
	}

}
}