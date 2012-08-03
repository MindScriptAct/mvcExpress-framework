package com.mindScriptAct.mvcExpressVisualizer.view {
import com.bit101.components.PushButton;
import com.mindScriptAct.mvcExpressVisualizer.controller.TestCommandA;
import com.mindScriptAct.mvcExpressVisualizer.messages.Message;
import com.mindScriptAct.mvcExpressVisualizer.VisualLoggerTestModule;
import flash.events.Event;
import flash.geom.Point;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
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
		testViewB2Button = new PushButton(view, 320, 560, "Mediator:Send Message", handleCommandB);
		testViewB2Button.width = 150
	}
	
	override public function onRemove():void {
	
	}
	
	private function handleCommandB(event:Event):void {
		sendMessage(Message.TEST_COMMAND_B, new Point(123, 321));
	}
}
}