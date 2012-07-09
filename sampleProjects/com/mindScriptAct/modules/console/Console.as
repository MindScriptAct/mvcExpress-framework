package com.mindScriptAct.modules.console {
import com.bit101.components.PushButton;
import com.bit101.components.TextArea;
import com.mindScriptAct.modules.console.controller.HandleGlobalMessageCommand;
import com.mindScriptAct.modules.console.controller.HandleInputCommand;
import com.mindScriptAct.modules.console.model.ConsoleLogProxy;
import com.mindScriptAct.modules.console.msg.ConsoleDataMsg;
import com.mindScriptAct.modules.console.msg.ConsoleMsg;
import com.mindScriptAct.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modules.console.view.ConsoleMediator;
import com.mindScriptAct.modules.globalMessages.GlobalMessage;
import com.mindScriptAct.modules.ModuleNames;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import org.mvcexpress.core.ModuleSprite;
import org.mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Console extends ModuleSprite {
	
	private var consoleId:int;
	
	public var outputTf:TextArea;
	public var inputTf:TextField;
	public var inputBtn:Sprite;
	
	public function Console(consoleId:int) {
		this.consoleId = consoleId;
		super(ModuleNames.CONSOLE + this.consoleId);
	}
	
	override protected function onInit():void {
		trace( "Console.onInit" );
		
		CONFIG::debug {
			checkClassStringConstants(ConsoleMsg, ConsoleDataMsg, ConsoleViewMsg);
		}
		
		
		commandMap.map(GlobalMessage.SEND_MESSAGE_TO_SPECIFIC_CONSOLE, HandleGlobalMessageCommand);
		commandMap.map(ConsoleViewMsg.INPUT_MESSAGE, HandleInputCommand);
		
		proxyMap.map(new ConsoleLogProxy(consoleId));
		
		mediatorMap.map(Console, ConsoleMediator);
		
		mediatorMap.mediate(this);
	
	}
	
	public function initConsole():void {
		// add message output
		outputTf = new TextArea();
		this.addChild(outputTf);
		outputTf.text = "Console #" + consoleId + " started.\n";
		
		outputTf.width = 300;
		outputTf.height = 100;
		outputTf.x = 5;
		outputTf.y = 5;
		
		// add message input
		
		inputTf = new TextField();
		this.addChild(inputTf);
		inputTf.text = '';
		inputTf.border = true;
		inputTf.type = TextFieldType.INPUT;
		
		inputTf.width = 300;
		inputTf.height = 22;
		inputTf.x = 5;
		inputTf.y = outputTf.x + outputTf.height + 5;
		
		inputBtn = new PushButton(this, inputTf.x + inputTf.width + 5, inputTf.y + 2, "send");
		inputBtn.width = 50;
		
	}
	
	override protected function onDispose():void {
		trace( "Console.onDispose" );
	}

}
}