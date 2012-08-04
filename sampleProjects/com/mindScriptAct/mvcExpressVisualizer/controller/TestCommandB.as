package com.mindScriptAct.mvcExpressVisualizer.controller {
import com.mindScriptAct.mvcExpressVisualizer.model.ITestProxyB;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyA;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyB;
import flash.geom.Point;
import org.mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestCommandB extends Command {
	
	[Inject]
	public var testProxyA:TestProxyA;
	
	[Inject(name="BProxyName")]
	public var testProxyB:ITestProxyB;
	
	public function execute(testPoint:Point):void {
	
	}

}
}