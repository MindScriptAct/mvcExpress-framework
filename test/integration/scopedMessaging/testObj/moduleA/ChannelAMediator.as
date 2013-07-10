package integration.scopedMessaging.testObj.moduleA {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ChannelAMediator extends Mediator {

	[Inject]
	public var view:ChannelViewA;

	//[Inject]
	//public var myProxy:MyProxy;

	override public function onRegister():void {
		view.addEventListener("addChannelHandler_test1", addChannelHandler1);
		view.addEventListener("addChannelHandler_test2", addChannelHandler2);
		view.addEventListener("addChannelHandler_testChannel_test3", addChannelHandler3);
		view.addEventListener("addChannelHandler_testChannel_test4_withParams", addChannelHandler4);
		view.addEventListener("removeChannelHandler_test1", removeChannelHandler1);
	}

	private function addChannelHandler1(event:Event):void {
		addScopeHandler("default", "test1", handleTest1Channelmessage);
	}

	private function addChannelHandler2(event:Event):void {
		addScopeHandler("default", "test2", handleTest2Channelmessage);
	}

	private function addChannelHandler3(event:Event):void {
		addScopeHandler("testChannel", "test3", handleTest3Channelmessage);
	}

	private function addChannelHandler4(event:Event):void {
		addScopeHandler("testChannel", "test4", handleTest4Channelmessage);
	}

	private function removeChannelHandler1(event:Event):void {
		removeScopeHandler("default", "test1", handleTest1Channelmessage);
	}

	private function handleTest1Channelmessage(blank:Object):void {
		trace("ChannelAMediator.handleTest1Channelmessage > blank : " + blank);
		view.test1handled = true;
	}

	private function handleTest2Channelmessage(blank:Object):void {
		trace("ChannelAMediator.handleTest2Channelmessage > blank : " + blank);
		view.test2handled = true;
	}

	private function handleTest3Channelmessage(blank:Object):void {
		trace("ChannelAMediator.handleTest3Channelmessage > blank : " + blank);
		view.test3handled = true;
	}

	private function handleTest4Channelmessage(testParams:String):void {
		trace( "ChannelAMediator.handleTest4Channelmessage > testParams : " + testParams );
		view.test4handled = true;
		view.test4params = testParams;
	}

	override public function onRemove():void {

	}

}
}