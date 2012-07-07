package com.mindScriptAct.circularDependenciesTest.view {
import com.mindScriptAct.circularDependenciesTest.model.AProxy;
import com.mindScriptAct.circularDependenciesTest.model.BProxy;
import com.mindScriptAct.circularDependenciesTest.model.CProxy;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewMediator extends Mediator {
	
	[Inject]
	public var view:TestView;
	
	[Inject]
	public var aProxy:AProxy;
	
	[Inject]
	public var bProxy:BProxy;
	
	[Inject]
	public var cProxy:CProxy;
	
	override public function onRegister():void {
		trace("TestViewMediator.onRegister");
		
		trace("3 proxy data sum is: "+ int(aProxy.data + bProxy.data + cProxy.data));
	
	}
	
	override public function onRemove():void {
	
	}

}
}