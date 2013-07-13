package com.mindScriptAct.modules.console.view {
import com.mindScriptAct.modules.console.Console;
import com.mindScriptAct.modules.console.msg.ConsoleDataMsg;
import com.mindScriptAct.modules.console.msg.ConsoleViewMsg;

import flash.events.MouseEvent;

import mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ConsoleMediator extends Mediator {

	[Inject]
	public var view:Console;

	override protected function onRegister():void {
		trace("ConsoleMediator.onRegister");
		view.inputBtn.addEventListener(MouseEvent.CLICK, handleInputText);

		addHandler(ConsoleDataMsg.MESSAGE_ADDED, handleMessageAdded);
		//addRemoteHandler(GlobalMessage.SEND_INPUT_MESSAGE_TO_ALL_DONT_STORE, handleMessageAdded, ModuleNames.SHELL);

		//addScopeHandler(ScopeNames.FIRST_SCOPE, GlobalMessage.SEND_TARGETED_INPUT_MESSAGE, handleTargeterMessage);

	}

	private function handleTargeterMessage(text:String):void {
		//trace( "ConsoleMediator.handleTargeterMessage > text : " + text );
	}

	override protected function onRemove():void {
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