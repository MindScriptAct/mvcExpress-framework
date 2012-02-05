package com.mindScriptAct.mvcExpressSpeedTest.controller {
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Inject5Command extends Command {
	
	[Inject]
	public var blankProxy1:BlankProxy;
	[Inject]
	public var blankProxy2:BlankProxy;
	[Inject]
	public var blankProxy3:BlankProxy;
	[Inject]
	public var blankProxy4:BlankProxy;
	[Inject]
	public var blankProxy5:BlankProxy;
	
	public function execute(params:Object):void {
		//trace("Inject1Command.execute > notice : " + notice);
	
	}

}
}