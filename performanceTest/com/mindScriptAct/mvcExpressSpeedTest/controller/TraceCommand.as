package com.mindScriptAct.mvcExpressSpeedTest.controller {
import flash.display.Sprite;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class TraceCommand extends Command {
	
	public function execute(params:String):void {
		trace( "TraceCommand.execute > params : " + params );
	}

}
}