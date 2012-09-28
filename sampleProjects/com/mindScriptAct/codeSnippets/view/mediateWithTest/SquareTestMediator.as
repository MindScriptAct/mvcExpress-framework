package com.mindScriptAct.codeSnippets.view.mediateWithTest {
import flash.display.Sprite;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SquareTestMediator extends Mediator{
	
	[Inject]
	public var view:Sprite;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		trace( "SquareTestMediator.onRegister" );
		
	}
	
	override public function onRemove():void{
		
	}
	
}
}