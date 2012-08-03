package com.mindScriptAct.mvcExpressVisualizer.controller {
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyA;
import org.mvcexpress.mvc.Command;
	
/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestCommandA extends Command{
	
	
	[Inject]
	public var testProxyA:TestProxyA;
	
	public function execute(testText:String):void{
		
	}
	
}
}