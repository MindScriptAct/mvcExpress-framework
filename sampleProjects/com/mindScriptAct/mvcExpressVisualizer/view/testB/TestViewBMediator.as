package com.mindScriptAct.mvcExpressVisualizer.view.testB {
import com.mindScriptAct.mvcExpressVisualizer.model.ITestProxyB;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewBMediator extends Mediator{
	
	[Inject]
	public var view:TestViewB;
	
	[Inject(name="BProxyName")]
	public var testProxyB:ITestProxyB;
	
	override public function onRegister():void{
		
	}
	
	override public function onRemove():void{
		
	}
	
}
}