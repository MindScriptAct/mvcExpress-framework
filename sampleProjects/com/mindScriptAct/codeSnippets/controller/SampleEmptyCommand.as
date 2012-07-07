package com.mindScriptAct.codeSnippets.controller {
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SampleEmptyCommand extends Command {
	
	
	public function execute(params:Object):void {
		trace("SampleEmptyCommand.execute > params : " + params);
	}

}
}