package com.mindScriptAct.mvcExpressSpeedTest.controller {
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;

import mvcexpress.mvc.PooledCommand;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class WithProxyCommViewsPooledCommand extends PooledCommand {

	[Inject]
	public var blankProxy:BlankProxy;

	public function execute(params:Object):void {
		//trace( "WithProxyCommViewsCommand.execute > msg : " + msg );
		blankProxy.sendTestMessage();
	}

}
}