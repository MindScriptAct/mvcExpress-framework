package com.mindScriptAct.mvcExpressVisualizer.view.testB {
import com.bit101.components.PushButton;
import com.mindScriptAct.mvcExpressVisualizer.messages.Message;
import com.mindScriptAct.mvcExpressVisualizer.model.ITestProxyB;
import flash.events.Event;
import flash.geom.Point;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewBMediator extends Mediator {
	
	[Inject]
	public var view:TestViewB;
	
	[Inject(name="BProxyName")]
	public var testProxyB:ITestProxyB;
	
	override public function onRegister():void {
		var pushButton:PushButton;
		pushButton = new PushButton(view, 15, 50, "Send command message", handleSendCommandMessage);
		pushButton.width = 150;
		pushButton = new PushButton(view, 15, 75, "Send mediator message", handleSendMediatorMessage);
		pushButton.width = 150;
		pushButton = new PushButton(view, 15, 100, "Triger proxy", handleSendProxyMessage);
		pushButton.width = 150;
		
		addHandler(Message.TEST_MESSAGE_TO_MEDIATORS_B, handleMediatorTest);
		addHandler(Message.TEST_PROXY_TO_MEDIATOR, handleProxyTest);
	}
	
	private function handleSendCommandMessage(event:Event):void {
		sendMessage(Message.TEST_MEDIATOR_B_COMMAND, new Point(11, 22));
	}
	
	private function handleSendMediatorMessage(event:Event):void {
		sendMessage(Message.TEST_MESSAGE_TO_MEDIATORS_A);
	}
	
	private function handleSendProxyMessage(event:Event):void {
		testProxyB.testFunction();
	}
	
	override public function onRemove():void {
		// do nothing.
	}
	
	private function handleProxyTest(blank:Object):void {
		// do nothing.
	}
	
	private function handleMediatorTest(blank:Object):void {
		// do nothing.
	}
}
}