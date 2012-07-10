package com.mindScriptAct.modules.console.controller {
import com.mindScriptAct.modules.console.model.ConsoleLogProxy;
import com.mindScriptAct.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modules.console.view.ConsoleParams;
import org.mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class HandleTargetedMessageCommand extends Command {
	
	[Inject]
	public var consoleLogProxy:ConsoleLogProxy;
	
	public function execute(consoleParams:ConsoleParams):void {
		for (var i:int = 0; i < consoleParams.targetConsoleIds.length; i++) {
			if (consoleParams.targetConsoleIds[i] == consoleLogProxy.consoleId) {
				sendMessage(ConsoleViewMsg.INPUT_MESSAGE, consoleParams.text);
				break;
			}
		}
	}

}
}