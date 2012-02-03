package com.mindScriptAct.modularSample.modules.console {
import com.bit101.components.PushButton;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.TextField;
import flash.text.TextFieldType;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Console extends Sprite {
	public var consoleModule:ConsoleModule;
	
	public var outputTf:TextField;
	public var inputTf:TextField;
	public var inputBtn:Sprite;
	
	
	public function Console() {
		consoleModule = new ConsoleModule(this);
	}
	
	public function init():void {
		// add message output
		outputTf = new TextField();
		this.addChild(outputTf);
		outputTf.text = '...';
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
		
		inputBtn = new PushButton(this, inputTf.x + inputTf.width + 5, inputTf.y +2, "send");
		inputBtn.width = 50;
	}

}
}