package com.mindScriptAct.pureLegsTest.controller {
import org.pureLegs.mvc.Command;
import com.mindScriptAct.pureLegsTest.model.BlankModel;

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