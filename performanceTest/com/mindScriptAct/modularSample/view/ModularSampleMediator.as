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
	private var console:Console;
	
	[Inject]
	public var view:ModularSample;
	
	override public function onRegister():void {
		trace("ModularSampleMediator.onRegister");
		
		console = new Console();
		
		view.addChild(console);
		
		var testConsoleBtn:PushButton = new PushButton(view, 100, 350, "Test console", handleConsoleTest);
	
	}
	
	public function handleConsoleTest(event:MouseEvent):void {
		trace("ModularSampleMediator.handleConsoleTest > event : " + event);
		sendMessage(ConsoleViewMsg.INPUT_MESSAGE, "... output some text to console...");
	}

}
}