package com.mindScriptAct.mvcExpressLiveVisualizer.view.test {
import com.mindScriptAct.mvcExpressLiveVisualizer.constants.ProvideIds;
import flash.display.Shape;
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class TestColorRectangleMediator extends Mediator{
	
	[Inject]
	public var view:TestColorRectangle;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		
		provide(view.testRectangle, ProvideIds.TESTVIEW + view.colorId);
		
	}
	
	override public function onRemove():void{
		
	}
	
}
}