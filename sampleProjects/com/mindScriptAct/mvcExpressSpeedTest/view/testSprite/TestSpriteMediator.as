package com.mindScriptAct.mvcExpressSpeedTest.view.testSprite {
import org.mvcexpress.mvc.Mediator;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;
import com.mindScriptAct.mvcExpressSpeedTest.notes.Note;

/**
 * ...
 * @author Deril (raima156@yahoo.com)
 */
public class TestSpriteMediator extends Mediator {
	
	[Inject]
	public var view:TestSprite;
	
	[Inject]
	public var testProxy:BlankProxy;
	
	public function TestSpriteMediator(){
		super();
	}
	
	public override function onRegister():void {
		view.x = Math.random() * 700;
		view.y = Math.random() * 300 + 300;
		
		addHandler(Note.COMMUNICATION_TEST, handleOjectSearch);
	
	}
	
	override public function onRemove():void {
		removeHandler(Note.COMMUNICATION_TEST, handleOjectSearch);
	}
	
	private function handleOjectSearch(objectId:int):void {
		if (view.uniqueId == objectId){
			//trace("object found: " + view.uniqueId + " " + view);
		}
	}

}
}