package com.mindScriptAct.mvcExpressSpeedTest.controller {
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankModel;
import org.mvcexpress.mvc.Command;

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