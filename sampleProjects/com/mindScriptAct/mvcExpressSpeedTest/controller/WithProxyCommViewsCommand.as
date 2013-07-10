package com.mindScriptAct.mvcExpressSpeedTest.controller {
import mvcexpress.mvc.Command;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class WithProxyCommViewsCommand extends Command {

	[Inject]
	public var blankProxy:BlankProxy;

	public function execute(params:Object):void {
		//trace( "WithProxyCommViewsCommand.execute > msg : " + msg );
		blankProxy.sendTestMessage();
	}

}
}