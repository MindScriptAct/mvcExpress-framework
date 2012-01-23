package com.mindScriptAct.pureLegsTest.controller {
import com.mindScriptAct.pureLegsTest.model.BlankModel;
import org.pureLegs.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class WithModelCommand extends Command {
	
	[Inject]
	public var blankModel:BlankModel;
	
	public function execute(params:Object):void {
		//trace( "WithModelCommand.execute > msg : " + msg );
	}

}
}