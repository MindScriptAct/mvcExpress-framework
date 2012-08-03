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
		var pushButton:PushButton = new PushButton(view, 20, 50, "Send B mediator message", handleSendTestMessage);
		pushButton.width = 150;
	}
	
	private function handleSendTestMessage(event:Event):void {
		sendMessage(Message.TEST_MEDIATOR_B_COMMAND, new Point(11, 22));
	}
	
	override public function onRemove():void {
	
	}

}
}