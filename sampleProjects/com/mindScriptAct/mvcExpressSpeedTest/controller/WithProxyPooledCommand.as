package com.mindScriptAct.mvcExpressSpeedTest.controller {
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;
import mvcexpress.mvc.PooledCommand;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class WithProxyPooledCommand extends PooledCommand {

	[Inject]
	public var blankProxy:BlankProxy;

	public function execute(params:Object):void {
		//trace( "WithProxyCommand.execute > msg : " + msg );
	}

}
}