package com.mindScriptAct.pureLegsSample.controller {
import org.pureLegs.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleEmptyCommand extends Command {
	
	
	override public function execute(params:Object):void {
		trace("SampleEmptyCommand.execute > params : " + params);
	}

}
}