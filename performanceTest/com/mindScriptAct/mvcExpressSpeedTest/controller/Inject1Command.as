package com.mindScriptAct.mvcExpressSpeedTest.controller {
import org.mvcexpress.messager.Notice;
import org.mvcexpress.mvc.Command;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankModel;

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