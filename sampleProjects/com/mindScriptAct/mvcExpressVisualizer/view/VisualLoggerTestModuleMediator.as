package com.mindScriptAct.mvcExpressVisualizer.view {
import com.bit101.components.PushButton;
import com.mindScriptAct.mvcExpressVisualizer.controller.TestCommandA;
import com.mindScriptAct.mvcExpressVisualizer.messages.Message;
import com.mindScriptAct.mvcExpressVisualizer.VisualLoggerTestModule;
import flash.events.Event;
import flash.geom.Point;
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class VisualLoggerTestModuleMediator extends Mediator {
	private var testViewB1Button:PushButton;
	private var testViewB2Button:PushButton;
	
	[Inject]
	public var view:VisualLoggerTestModule;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
	}
	
	override public function onRemove():void {
	}

}
}