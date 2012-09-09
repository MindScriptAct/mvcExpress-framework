package integration.channeling.testObj.moduleB {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
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
	}
	
	private function sendChannelMessage1(event:Event):void {
		sendChannelMessage("test1");
	}
	
	private function sendChannelMessage2(event:Event):void {
		sendChannelMessage("test2");
	}
	
	private function sendChannelMessage3(event:Event):void {
		sendChannelMessage("test3", null, "testChannel");
	}
	
	override public function onRemove():void {
	
	}

}
}