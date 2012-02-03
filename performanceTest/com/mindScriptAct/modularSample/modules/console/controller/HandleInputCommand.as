package com.mindScriptAct.modularSample.modules.console.controller {
import com.mindScriptAct.modularSample.modules.console.model.ConsoleLogModel;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class HandleInputCommand extends Command {
	
	[Inject]
	public var consoleLogModel:ConsoleLogModel;
	
	public function execute(messageText:String):void {
		//trace("HandleInputCommand.execute > messageText : " + messageText);
		consoleLogModel.pushMessage(messageText);
	}

}
}