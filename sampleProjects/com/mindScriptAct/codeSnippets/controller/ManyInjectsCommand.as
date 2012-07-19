package com.mindScriptAct.codeSnippets.controller {
import com.mindScriptAct.codeSnippets.model.ISampleProxy;
import com.mindScriptAct.codeSnippets.model.SampleProxy;
import org.mvcexpress.mvc.Command;
	
/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ManyInjectsCommand extends Command{
	
	[Inject]
	public var sample:SampleProxy;
	
	[Inject]
	public var sampleInterface:ISampleProxy;	
	
	[Inject(name='testType')]
	public var sampleNamed:SampleProxy;
	
	[Inject(name='interfaceProxy')]
	public var sampleInterfaceNamed:ISampleProxy;		
	
	public function execute(blank:Object):void {
		trace( "ManyInjectsCommand.execute > blank : " + blank );
	}
	
}
}