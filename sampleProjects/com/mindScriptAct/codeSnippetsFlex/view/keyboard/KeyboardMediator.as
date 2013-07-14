package com.mindScriptAct.codeSnippetsFlex.view.keyboard {
import flash.display.Stage;

import mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author
 */
public class KeyboardMediator extends Mediator {

	[Inject]
	public var stage:Stage;

	override protected function onRegister():void {
		trace("KeyboardMediator.onRegister", stage);
	}

}
}