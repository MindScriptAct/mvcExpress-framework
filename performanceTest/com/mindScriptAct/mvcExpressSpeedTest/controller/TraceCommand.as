package com.mindScriptAct.mvcExpressSpeedTest.controller {
import flash.display.Sprite;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class TraceCommand extends Command {
	
	public function execute(params:String):void {
		trace( "TraceCommand.execute > params : " + params );
	}

}
}