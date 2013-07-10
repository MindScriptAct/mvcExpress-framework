package com.mindScriptAct.mvcExpressVisualizer.controller {
import com.mindScriptAct.mvcExpressVisualizer.messages.Message;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyA;
import mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestCommandA extends Command {

	[Inject]
	public var testProxyA:TestProxyA;

	public function execute(testText:String):void {
		sendMessage(Message.TEST_COMMAND_TO_MEDIATOR);
	}

}
}