package com.mindScriptAct.mvcExpressVisualizer.controller {
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyA;
import flash.geom.Point;
import org.mvcexpress.mvc.Command;
	
/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestCommandB extends Command{
	
	
	[Inject]
	public var testProxyA:TestProxyA;
	
	public function execute(testPoint:Point):void{
		
	}
	
}
}