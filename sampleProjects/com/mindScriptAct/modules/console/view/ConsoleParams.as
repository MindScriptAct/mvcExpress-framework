package com.mindScriptAct.modules.console.view {

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ConsoleParams {
	public var text:String;
	public var targetConsoleIds:Array;
	
	public function ConsoleParams(text:String, targetConsoleIds:Array) {
		this.text = text;
		this.targetConsoleIds = targetConsoleIds;
	}

}
}