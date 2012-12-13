package com.mindScriptAct.mvcExpressLive.view.guiTest {
import com.bit101.components.Panel;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class LiveGuiTestMediator extends Mediator {
	
	[Inject]
	public var view:LiveGuiTest;
	
	[Provide (name="guiPanelTest")]
	public var panel:Panel = new Panel(null, 50, 300);
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		trace("LiveGuiTestMediator.onRegister");
		
		view.addChild(panel);
	}
	
	override public function onRemove():void {
	
	}

}
}