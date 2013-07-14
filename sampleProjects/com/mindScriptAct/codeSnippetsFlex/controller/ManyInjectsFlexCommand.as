package com.mindScriptAct.codeSnippetsFlex.controller {
import com.mindScriptAct.codeSnippets.model.ISampleProxy;
import com.mindScriptAct.codeSnippets.model.SampleProxy;

import mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ManyInjectsFlexCommand extends Command {

	[Inject]
	public var sample:SampleProxy;

	[Inject]
	public var sampleInterface:ISampleProxy;

	[Inject(name='testType')]
	public var sampleNamed:SampleProxy;

	[Inject(name='interfaceProxy')]
	public var sampleInterfaceNamed:ISampleProxy;

	public function execute(blank:Object):void {
		trace("ManyInjectsCommand.execute > blank : " + blank);
	}

}
}