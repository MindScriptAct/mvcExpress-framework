package com.mindScriptAct.codeSnippetsFlex.view.flexObj {
import mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class TestTileFlexWindowMediator extends Mediator {

	[Inject]
	public var view:TestTileFlexWindow;

	override protected function onRegister():void {
		trace("TestTileWindow mediated!");
	}

	override protected function onRemove():void {
		trace("Warning: TestTileWindowMediator onRemove() is not implemented!");
	}
}
}