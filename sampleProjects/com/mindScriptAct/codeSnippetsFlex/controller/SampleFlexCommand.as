package com.mindScriptAct.codeSnippetsFlex.controller {
import com.mindScriptAct.codeSnippetsFlex.messages.MsgFlex;
import com.mindScriptAct.codeSnippetsFlex.model.SampleFlexProxy;

import mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SampleFlexCommand extends Command {

	////////////////////////////
	// geting proxies...
	////////////////////////////
	[Inject]
	public var sampleProxy:SampleFlexProxy;

	// execute MUST have 1 and only one parameter. This parameter can be typed(or be Object type)

	public function execute(params:Object):void {
		trace("SampleCommand.execute > params : " + params);

		sampleProxy.sendTestMessage();

		////////////////////////////
		// Proxy
		////////////////////////////

		proxyMap

		////////////////////////////
		// view
		////////////////////////////

		mediatorMap

		////////////////////////////
		// view
		////////////////////////////

		commandMap

		////////////////////////////
		// comunication
		////////////////////////////

		sendMessage(MsgFlex.TEST_DATA_MESSAGE, "send some data to listeners......");

	}

}
}