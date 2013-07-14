package com.mindScriptAct.codeSnippetsFlex.controller {
import mvcexpress.mvc.Command;

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