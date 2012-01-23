package com.mindScriptAct.pureLegsTest.controller {
import org.pureLegs.messager.Notice;
import org.pureLegs.mvc.Command;
import com.mindScriptAct.pureLegsTest.model.BlankModel;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Inject1Command extends Command {
	
	[Inject]
	public var blankModel:BlankModel;
	
	override public function execute(notice:Notice):void {
		trace( "Inject1Command.execute > notice : " + notice );
	
		
		//commandMap.execute
		
		//mediatorMap
		
		//modelMap..
		
		messenger.
	}

}
}