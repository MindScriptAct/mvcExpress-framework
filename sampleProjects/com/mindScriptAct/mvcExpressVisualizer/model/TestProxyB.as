package com.mindScriptAct.mvcExpressVisualizer.model {
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestProxyB extends Proxy implements ITestProxyB {
	
	[Inject]
	public var testProxyA:TestProxyA;
	
	public function TestProxyB() {
	
	}
	
	override protected function onRegister():void {
	
	}
	
	override protected function onRemove():void {
	
	}
	
	/* INTERFACE com.mindScriptAct.mvcExpressVisualizer.model.ITestProxyB */
	
	public function testFunction():void {
	
	}
}
}