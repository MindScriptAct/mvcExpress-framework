package com.mindScriptAct.codeSnippets.view.keyboard {
import flash.display.Stage;
import mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author
 */
public class KeyboardMediator extends Mediator {

	[Inject]
	public var stage:Stage;

	override public function onRegister():void {
		trace("KeyboardMediator.onRegister", stage);
	}

}
}