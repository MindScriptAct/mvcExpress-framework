package com.mindScriptAct.codeSnippets.controller {
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class SampleEmptyCommand extends Command {
	
	
	override public function execute(params:Object):void {
		trace("SampleEmptyCommand.execute > params : " + params);
	}

}
}