package com.mindScriptAct.codeSnippets.view.mediateWithTest {
import flash.display.Sprite;
import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class CircleTestMediator extends Mediator{

	[Inject]
	public var view:Sprite;

	//[Inject]
	//public var myProxy:MyProxy;

	override public function onRegister():void {
		trace( "CircleTestMediator.onRegister" );

	}

	override public function onRemove():void{

	}

}
}