package com.mindScriptAct.mvcExpressSpeedTest.module {
import com.mindScriptAct.mvcExpressSpeedTest.AppModule;
import com.mindScriptAct.mvcExpressSpeedTest.view.testSprite.TestSprite;
import mvcexpress.mvc.Mediator;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;
import com.mindScriptAct.mvcExpressSpeedTest.notes.Note;

/**
 * ...
 * @author Deril (http://www.mindscriptact.com/)
 */
public class ModuleTestSpriteMediator extends Mediator {

	[Inject]
	public var view:TestSprite;

	[Inject]
	public var testProxy:BlankProxy;

	public function ModuleTestSpriteMediator() {
		super();
	}

	public override function onRegister():void {
		view.x = Math.random() * 700;
		view.y = Math.random() * 300 + 300;

		addScopeHandler(AppModule.SPEED_TEST_SCOPE, Note.COMMUNICATION_TEST, handleOjectSearch);

	}

	override public function onRemove():void {
		removeScopeHandler(AppModule.SPEED_TEST_SCOPE, Note.COMMUNICATION_TEST, handleOjectSearch);
	}

	private function handleOjectSearch(objectId:int):void {
		if (view.uniqueId == objectId) {
			//trace("object found: " + view.uniqueId + " " + view);
		}
	}

}
}