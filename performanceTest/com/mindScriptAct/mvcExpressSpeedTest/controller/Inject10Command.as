package com.mindScriptAct.mvcExpressSpeedTest.controller {
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankModel;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Inject10Command extends Command {
	
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
	[Inject]
	public var blankModel7:BlankModel;
	[Inject]
	public var blankModel8:BlankModel;
	[Inject]
	public var blankModel9:BlankModel;
	[Inject]
	public var blankModel10:BlankModel;
	
	public function execute(params:Object):void {
		//trace("Inject1Command.execute > notice : " + notice);
	
	}

}
}