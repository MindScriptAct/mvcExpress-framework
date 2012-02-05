package com.mindScriptAct.mvcExpressSpeedTest.controller {
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class WithProxyCommand extends Command {
	
	[Inject]
	public var blankProxy:BlankProxy;
	
	public function execute(params:Object):void {
		//trace( "WithProxyCommand.execute > msg : " + msg );
	}

}
}