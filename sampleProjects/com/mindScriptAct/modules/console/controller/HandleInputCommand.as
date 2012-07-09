package com.mindScriptAct.modules.console.controller {
import com.mindScriptAct.modules.console.model.ConsoleLogProxy;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class HandleInputCommand extends Command {
	
	[Inject]
	public var consoleLogProxy:ConsoleLogProxy;
	
	public function execute(messageText:String):void {
		//trace("HandleInputCommand.execute > messageText : " + messageText);
		consoleLogProxy.pushMessage(messageText);
	}

}
}