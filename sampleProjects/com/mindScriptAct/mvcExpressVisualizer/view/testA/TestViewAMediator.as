package com.mindScriptAct.mvcExpressVisualizer.view.testA {
import com.bit101.components.PushButton;
import com.mindScriptAct.mvcExpressVisualizer.messages.Message;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyA;
import flash.events.Event;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewAMediator extends Mediator {
	
	[Inject]
	public var view:TestViewA;
	
	[Inject]
	public var testProxyA:TestProxyA;
	
	override public function onRegister():void {
		var pushButton:PushButton = new PushButton(view, 20, 50, "Send A mediator message", handleSendTestMessage);
		pushButton.width = 150;
	}
	
	private function handleSendTestMessage(event:Event):void {
		sendMessage(Message.TEST_MEDIATOR_A_COMMAND, "A params..");
	}
	
	override public function onRemove():void {
	
	}

}
}