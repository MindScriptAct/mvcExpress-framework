package com.mindScriptAct.codeSnippets.view.mediateWithTest {
import flash.display.Sprite;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SquareTestMediator extends Mediator {

	[Inject]
	public var view:Sprite;

	//[Inject]
	//public var myProxy:MyProxy;

	override protected function onRegister():void {
		trace("SquareTestMediator.onRegister");

	}

	override protected function onRemove():void {

	}

}
}