package com.mindScriptAct.mvcExpressSpeedTest.controller {
import org.mvcexpress.mvc.PooledCommand;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class EmptyPooledCommand extends PooledCommand {
	
	public function execute(params:Object):void {
		//trace("TestCommand.execute");
	}

}
}