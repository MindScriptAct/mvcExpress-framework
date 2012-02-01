package com.mindScriptAct.mvcExpressSpeedTest.controller {
import org.mvcexpress.mvc.Command;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankModel;

/**
 * COMMENT
 * @author rbanevicius
 */
public class WithModelCommViewsCommand extends Command {
	
	[Inject]
	public var blankModel:BlankModel;
	
	public function execute(params:Object):void {
		//trace( "WithModelCommViewsCommand.execute > msg : " + msg );
		blankModel.sendTestMessage();
	}

}
}