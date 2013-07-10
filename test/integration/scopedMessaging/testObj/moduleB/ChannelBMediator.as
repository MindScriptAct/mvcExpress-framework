package integration.scopedMessaging.testObj.moduleB {
import flash.display.Sprite;
import flash.events.Event;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ChannelBMediator extends Mediator {

	[Inject]
	public var view:Sprite;

	//[Inject]
	//public var myProxy:MyProxy;

	override public function onRegister():void {
		view.addEventListener("sendChannelMessage_test1", sendChannelMessage1);
		view.addEventListener("sendChannelMessage_test2", sendChannelMessage2);
		view.addEventListener("sendChannelMessage_testChannel_test3", sendChannelMessage3);
		view.addEventListener("sendChannelMessage_testChannel_test4_withParams", sendChannelMessage4);
	}

	private function sendChannelMessage1(event:Event):void {
		sendScopeMessage("default", "test1");
	}

	private function sendChannelMessage2(event:Event):void {
		sendScopeMessage("default", "test2");
	}

	private function sendChannelMessage3(event:Event):void {
		sendScopeMessage("testChannel", "test3", null);
	}

	private function sendChannelMessage4(event:Event):void {
		sendScopeMessage("testChannel", "test4", "test4 params string");
	}

	override public function onRemove():void {

	}

}
}