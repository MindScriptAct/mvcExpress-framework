package com.mindScriptAct.pureLegsTest.controller {
import com.mindScriptAct.pureLegsTest.model.BlankModel;
import org.pureLegs.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Inject5Command extends Command {
	
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
	
	public function execute(params:Object):void {
		//trace("Inject1Command.execute > notice : " + notice);
	
	}

}
}