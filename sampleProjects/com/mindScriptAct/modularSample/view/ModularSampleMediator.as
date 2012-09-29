package com.mindScriptAct.modularSample.view {
import com.bit101.components.PushButton;
import com.mindScriptAct.modularSample.constants.ScopeNames;
import com.mindScriptAct.modularSample.ModularSample;
import com.mindScriptAct.modules.console.Console;
import com.mindScriptAct.modules.console.msg.ConsoleMsg;
import com.mindScriptAct.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modules.globalMessages.GlobalMessage;
import flash.events.Event;
import flash.events.MouseEvent;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModularSampleMediator extends Mediator {
	
	[Inject]
	public var view:ModularSample;
	
	private var console1:Console;
	private var console2:Console;
	private var console3:Console;
	private var console4:Console;
	private var cosnole1Button:PushButton;
	private var cosnole2Button:PushButton;
	private var cosnole3Button:PushButton;
	private var cosnole4Button:PushButton;
	
	override public function onRegister():void {
		trace("ModularSampleMediator.onRegister");
		
		new PushButton(view, 500, 370, "Test global message", handleMessageToAll);
		
		cosnole1Button = new PushButton(view, 20, 350, "Add console #1", handleAddConsole1);
		cosnole2Button = new PushButton(view, 150, 350, "Add console #2", handleAddConsole2);
		cosnole3Button = new PushButton(view, 20, 380, "Add console #3", handleAddConsole3);
		cosnole4Button = new PushButton(view, 150, 380, "Add console #4", handleAddConsole4);
		
		new PushButton(view, 500, 345, "message to #1", handleMessageToFirst).width = 150;
		new PushButton(view, 500, 370, "message to #2 and #4", handleMessageToEven).width = 150;
		new PushButton(view, 500, 395, "message to all", handleMessageToAll).width = 150;
		//new PushButton(view, 500, 425, "message to all no store", handleMessageToAllNoStore).width = 150;
		//new PushButton(view, 500, 525, "testing....", handleMessageToAllDublicate).width = 150;
	}
	
	override public function onRemove():void {
		trace("ModularSampleMediator.onRemove");
	}
	
	private function handleAddConsole1(event:Event):void {
		if (console1) {
			view.removeChild(console1);
			console1.disposeModule();
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
			console2.disposeModule();
			console2 = null;
			cosnole2Button.label = "Add console #2";
		} else {
			console2 = new Console(2);
			console2.x = 400;
			view.addChild(console2);
			cosnole2Button.label = "Remove console #2";
		}
	}
	
	private function handleAddConsole3(event:Event):void {
		if (console3) {
			view.removeChild(console3);
			console3.disposeModule();
			console3 = null;
			cosnole3Button.label = "Add console #3";
		} else {
			console3 = new Console(3);
			console3.y = 150;
			view.addChild(console3);
			cosnole3Button.label = "Remove console #3";
		}
	}
	
	private function handleAddConsole4(event:Event):void {
		if (console4) {
			view.removeChild(console4);
			console4.disposeModule();
			console4 = null;
			cosnole4Button.label = "Add console #4";
		} else {
			console4 = new Console(4);
			console4.x = 400;
			console4.y = 150;
			view.addChild(console4);
			cosnole4Button.label = "Remove console #4";
		}
	}
	
	public function handleMessageToFirst(event:MouseEvent):void {
		sendScopeMessage(ScopeNames.FIRST_SCOPE, GlobalMessage.SEND_TARGETED_INPUT_MESSAGE, "Message to FIRST module!!!");
	}
	
	public function handleMessageToEven(event:MouseEvent):void {
		sendScopeMessage(ScopeNames.EVEN_SCOPE, GlobalMessage.SEND_TARGETED_INPUT_MESSAGE, "Message to even modules!!! (2 and 4)");
	}
	
	public function handleMessageToAll(event:MouseEvent):void {
		sendScopeMessage(ScopeNames.ALL_SCORE, GlobalMessage.SEND_TARGETED_INPUT_MESSAGE, "Global message to all modules!!!");
	}
	
	//public function handleMessageToAllNoStore(event:MouseEvent):void {
		//sendMessageToAll(GlobalMessage.SEND_INPUT_MESSAGE_TO_ALL_DONT_STORE, "Global message to all modules without using proxy!!!");
	//}
	//
	//public function handleMessageToAllDublicate(event:MouseEvent):void {
		//sendMessageToAll(ConsoleViewMsg.INPUT_MESSAGE, "Global message to all modules without using proxy!!!");
	//}
}
}