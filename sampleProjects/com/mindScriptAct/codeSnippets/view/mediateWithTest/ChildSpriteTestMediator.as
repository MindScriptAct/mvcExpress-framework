package com.mindScriptAct.codeSnippets.view.mediateWithTest {
import flash.display.Sprite;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ChildSpriteTestMediator extends Mediator {

	[Inject]
	public var view:ChildSpriteTest;

	//[Inject]
	//public var myProxy:MyProxy;

	override protected function onRegister():void {
		var circle:Sprite = new Sprite();
		view.addChild(circle);
		mediatorMap.mediateWith(circle, CircleTestMediator);

		var square:Sprite = new Sprite();
		view.addChild(square);
		mediatorMap.mediateWith(square, SquareTestMediator);
		mediatorMap.unmediate(square);
		mediatorMap.mediateWith(square, SquareTestMediator);

	}

	override protected function onRemove():void {

	}

}
}