package com.mindScriptAct.modularSample.view {
import com.bit101.components.PushButton;
import com.mindScriptAct.modularSample.ModularSample;
import com.mindScriptAct.modularSample.modules.console.Console;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleViewMsg;
import flash.events.Event;
import flash.events.MouseEvent;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ModularSampleMediator extends Mediator {
	
	[Inject]
	public var view:ModularSample;
	
	private var console1:Console;
	private var console2:Console;
	private var cosnole1Button:PushButton;
	private var cosnole2Button:PushButton;
	
	override public function onRegister():void {
		trace("ModularSampleMediator.onRegister");
		
		new PushButton(view, 300, 370, "Test console", handleConsoleTest);
		
		cosnole1Button = new PushButton(view, 20, 350, "Add console #1", handleAddConsole1);
		cosnole2Button = new PushButton(view, 20, 380, "Add console #2", handleAddConsole2);
	
	}
	
	private function handleAddConsole1(event:Event):void {
		if (console1) {
			view.removeChild(console1);
			console1.dispose();
			console1 = null;
			cosnole1Button.label = "Add console #1";
		} else {
			console1 = new Console(1);
			view.addChild(console1);
			cosnole1Button.label = "Remove console #1";
		}
	}
	
	private function handleAddConsole2(event:Event):void {
		if (console2) {
			view.removeChild(console2);
			console2.dispose();
			console2 = null;
			cosnole2Button.label = "Add console #2";
		} else {
			console2 = new Console(2);
			console2.x = 400;
			view.addChild(console2);
			cosnole2Button.label = "Remove console #2";
		}
	}
	
	public function handleConsoleTest(event:MouseEvent):void {
		trace("ModularSampleMediator.handleConsoleTest > event : " + event);
		sendMessage(ConsoleViewMsg.INPUT_MESSAGE, "... output some text to console...");
	}

}
}