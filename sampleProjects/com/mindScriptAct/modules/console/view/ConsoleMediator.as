package com.mindScriptAct.modules.console.view {
import com.mindScriptAct.modules.console.Console;
import com.mindScriptAct.modules.console.msg.ConsoleDataMsg;
import com.mindScriptAct.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modules.globalMessages.GlobalMessage;
import com.mindScriptAct.modules.ModuleNames;
import flash.events.MouseEvent;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ConsoleMediator extends Mediator {
	
	[Inject]
	public var view:Console;
	
	override public function onRegister():void {
		trace("ConsoleMediator.onRegister");
		view.inputBtn.addEventListener(MouseEvent.CLICK, handleInputText);
		
		addHandler(ConsoleDataMsg.MESSAGE_ADDED, handleMessageAdded);
		addHandler(GlobalMessage.SEND_INPUT_MESSAGE_TO_ALL_DONT_STORE, handleMessageAdded, ModuleNames.SHELL);
		
	}
	
	override public function onRemove():void {
		trace("ConsoleMediator.onRemove");
	}
	
	private function handleInputText(event:MouseEvent):void {
		trace("Console.handleTextInput > event : " + event);
		if (view.inputTf.text) {
			
			sendMessage(ConsoleViewMsg.INPUT_MESSAGE, view.inputTf.text);
			
			view.inputTf.text = "";
			
		} else {
			sendMessage(ConsoleViewMsg.EMPTY_MESSAGE, "NO MESSAGE ENTERED!!.....");
		}
	
	}
	
	private function handleMessageAdded(message:String):void {
		view.outputTf.text += message + "\n";
		view.outputTf.textField.scrollV = view.outputTf.textField.maxScrollV;
	}

}
}