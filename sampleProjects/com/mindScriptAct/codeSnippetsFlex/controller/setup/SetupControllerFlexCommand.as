package com.mindScriptAct.codeSnippetsFlex.controller.setup {
import com.mindScriptAct.codeSnippets.controller.SampleCommand;
import com.mindScriptAct.codeSnippets.messages.Msg;

import mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class SetupControllerFlexCommand extends Command {

	public function execute(blank:Object):void {
		////////////////////////////
		// controller
		////////////////////////////
		commandMap.map(Msg.TEST, SampleCommand);
		//commandMap.unmap(Msg.TEST, SampleCommand);
	}

}
}
