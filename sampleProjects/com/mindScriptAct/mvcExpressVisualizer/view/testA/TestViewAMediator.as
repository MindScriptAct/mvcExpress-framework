package com.mindScriptAct.mvcExpressVisualizer.view.testA {
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyA;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewAMediator extends Mediator{
	
	[Inject]
	public var view:TestViewA;
	
	[Inject]
	public var testProxyA:TestProxyA;
	
	override public function onRegister():void{
		
	}
	
	override public function onRemove():void{
		
	}
	
}
}