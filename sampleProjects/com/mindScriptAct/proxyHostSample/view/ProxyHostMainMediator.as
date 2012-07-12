package com.mindScriptAct.proxyHostSample.view {
import com.mindScriptAct.modules.counter.CounterModule;
import com.mindScriptAct.proxyHostSample.messages.DataMessage;
import com.mindScriptAct.proxyHostSample.model.TestProxy;
import com.mindScriptAct.proxyHostSample.ProxyHostMain;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.text.TextField;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ProxyHostMainMediator extends Mediator {
	
	[Inject]
	public var view:ProxyHostMain;
	
	[Inject]
	public var testProxy:TestProxy;
	
	private var infoText:TextField;
	
	override public function onRegister():void {
		addListener(view.stage, MouseEvent.CLICK, handleMouseClick);
		
		addHandler(DataMessage.COUNTER_CHANGED, handleCounterChange);
		
		infoText = new TextField();
		view.addChild(infoText);
		infoText.text = '';
		
		//
		var counterModule:CounterModule = new CounterModule();
		view.addChild(counterModule);
		counterModule.x = 400;
	}
	
	public function handleCounterChange(blank:Object):void {
		infoText.text = 'Main count:' + testProxy.getCount();
	}
	
	private function handleMouseClick(event:MouseEvent):void {
		//trace("ProxyHostMainMediator.handleMouseClick > event : " + event);
		
		var circle:Shape = new Shape();
		circle.graphics.lineStyle(0.1, 0xFF0000);
		circle.graphics.beginFill(0x0000FF);
		circle.graphics.drawCircle(0, 0, 10);
		circle.graphics.endFill();
		
		view.addChild(circle);
		
		circle.x = view.mouseX;
		circle.y = view.mouseY;
		
		testProxy.increaseCircleCount();
	
	}
	
	override public function onRemove():void {
	
	}

}
}