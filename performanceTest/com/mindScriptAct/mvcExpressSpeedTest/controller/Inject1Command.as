package com.mindScriptAct.mvcExpressSpeedTest.controller {
import org.mvcexpress.messager.Notice;
import org.mvcexpress.mvc.Command;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Inject1Command extends Command {
	
	[Inject]
	public var blankProxy:BlankProxy;
	
	override public function execute(notice:Notice):void {
		trace( "Inject1Command.execute > notice : " + notice );
	
		
		//commandMap.execute
		
		//mediatorMap...
		
		//proxyMap...
		
		messenger.
	}

}
}