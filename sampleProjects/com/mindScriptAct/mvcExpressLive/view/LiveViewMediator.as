package com.mindScriptAct.mvcExpressLive.view {
import com.bit101.components.PushButton;
import flash.events.Event;
import flash.utils.setTimeout;
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class LiveViewMediator extends Mediator {
	
	[Inject]
	public var view:LiveView;
	
	public var liveVectorObjects:Vector.<LiveViewTest> = new Vector.<LiveViewTest>();
	
	override public function onRegister():void {
		trace("LiveViewMediator.onRegister");
		
		var obj1:LiveViewTest = new LiveViewTest();
		view.addChild(obj1);
		var obj2:LiveViewTest = new LiveViewTest();
		view.addChild(obj2);
		
		liveVectorObjects.push(obj1);
		liveVectorObjects.push(obj2);
		
		processMap.provide(liveVectorObjects, "liveViewObjects");
		
		//setTimeout(addOneMore, 2000);
		
		var unprovideBtn:PushButton = new PushButton(view, 5, 5, "unprovideTest", handleUnprovideTest);
	}
	
	private function handleUnprovideTest(event:Event):void {
		processMap.unprovide(liveVectorObjects, "liveViewObjects");
	}
	
	public function addOneMore():void {
		var obj1:LiveViewTest = new LiveViewTest();
		view.addChild(obj1);
		liveVectorObjects.push(obj1);
	}
	
	override public function onRemove():void {
	
	}

}
}