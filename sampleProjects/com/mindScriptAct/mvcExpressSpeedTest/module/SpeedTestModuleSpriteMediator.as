package com.mindScriptAct.mvcExpressSpeedTest.module {
import com.mindScriptAct.mvcExpressSpeedTest.AppModule;
import com.mindScriptAct.mvcExpressSpeedTest.notes.Note;
import com.mindScriptAct.mvcExpressSpeedTest.view.testSprite.TestSprite;
import flash.display.Sprite;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class SpeedTestModuleSpriteMediator extends Mediator {
	
	[Inject]
	public var view:SpeedTestModuleSprite;
	
	private var childStack:Vector.<TestSprite> = new Vector.<TestSprite>();
	
	private var childHolder:Sprite = new Sprite();
	
	override public function onRegister():void {
		
		view.addChild(childHolder);
		
		addScopeHandler(AppModule.SPEED_TEST_SCOPE, Note.CREATE_TEST_VIEW, handleCreateTestSprite);
		addScopeHandler(AppModule.SPEED_TEST_SCOPE, Note.REMOVE_TEST_VIEW, handleRemoveTestSprite);
	
	}
	
	private function handleCreateTestSprite(objectId:int):void {
		var newObject:TestSprite = new TestSprite(objectId);
		mediatorMap.mediate(newObject);
		childStack.push(newObject);
		childHolder.addChild(newObject);
	}
	
	private function handleRemoveTestSprite(objectId:int):void {
		var oldObject:TestSprite = childStack.pop();
		if (oldObject) {
			childHolder.removeChild(oldObject);
			mediatorMap.unmediate(oldObject);
		}
	}
	
	override public function onRemove():void {
	
	}

}
}