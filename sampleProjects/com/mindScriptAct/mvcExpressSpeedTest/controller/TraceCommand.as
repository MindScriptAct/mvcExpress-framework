package com.mindScriptAct.mvcExpressSpeedTest.controller {
import flash.display.Sprite;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceCommand extends Command {
	
	public function execute(params:String):void {
		trace( "TraceCommand.execute > params : " + params );
	}

}
}