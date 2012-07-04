package com.mindScriptAct.modularSample.modules.console {
import com.bit101.components.PushButton;
import com.mindScriptAct.modularSample.modules.console.controller.HandleInputCommand;
import com.mindScriptAct.modularSample.modules.console.model.ConsoleLogProxy;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleDataMsg;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleMsg;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modularSample.modules.console.view.ConsoleMediator;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import org.mvcexpress.core.ModuleSprite;
import org.mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class Console extends ModuleSprite {
	
	private var consoleId:int;
	
	public var outputTf:TextField;
	public var inputTf:TextField;
	public var inputBtn:Sprite;
	
	public function Console(consoleId:int) {
		this.consoleId = consoleId;
		super("console" + this.consoleId);
	}
	
	override protected function onInit():void {
		trace("ConsoleModule.onStartUp");
		
		CONFIG::debug {
			checkClassStringConstants(ConsoleMsg, ConsoleDataMsg, ConsoleViewMsg);
		}
		
		commandMap.map(ConsoleViewMsg.INPUT_MESSAGE, HandleInputCommand);
		
		proxyMap.map(new ConsoleLogProxy());
		
		mediatorMap.map(Console, ConsoleMediator);
		
		mediatorMap.mediate(this);
	
	}
	
	public function initConsole():void {
		// add message output
		outputTf = new TextField();
		this.addChild(outputTf);
		outputTf.text = "Console #" + consoleId + " started.\n";
		outputTf.border = true;
		
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

}
}