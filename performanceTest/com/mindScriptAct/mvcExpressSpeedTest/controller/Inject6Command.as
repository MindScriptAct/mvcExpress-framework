package com.mindScriptAct.mvcExpressSpeedTest.controller {
import org.mvcexpress.mvc.Command;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankModel;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Inject6Command extends Command {
	
	[Inject]
	public var blankModel1:BlankModel;
	[Inject]
	public var blankModel2:BlankModel;
	[Inject]
	public var blankModel3:BlankModel;
	[Inject]
	public var blankModel4:BlankModel;
	[Inject]
	public var blankModel5:BlankModel;
	[Inject]
	public var blankModel6:BlankModel;
	
	public function execute(params:Object):void {
		//trace("Inject1Command.execute > notice : " + notice);
	
	}

}
}