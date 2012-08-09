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
		var pushButton:PushButton;
		pushButton = new PushButton(view, 15, 50, "Send command message", handleSendCommandMessage);
		pushButton.width = 150;
		pushButton = new PushButton(view, 15, 75, "Send mediator message", handleSendMediatorMessage);
		pushButton.width = 150;
		pushButton = new PushButton(view, 15, 100, "Triger proxy", handleSendProxyMessage);
		pushButton.width = 150;
		
		addHandler(Message.TEST_MESSAGE_TO_MEDIATORS_A, handleMediatorTest);
		addHandler(Message.TEST_MODULE_TO_MEDIATORS_A, handleMediatorTest);
	}
	
	private function handleMediatorTest(blank:Object):void {
	
	}
	
	private function handleSendCommandMessage(event:Event):void {
		sendMessage(Message.TEST_MEDIATOR_A_COMMAND, "A params..");
	}
	
	private function handleSendMediatorMessage(event:Event):void {
		sendMessage(Message.TEST_MESSAGE_TO_MEDIATORS_B);
	}
	
	private function handleSendProxyMessage(event:Event):void {
		testProxyA.changeSomething();
	}
	
	override public function onRemove():void {
	
	}

}
}