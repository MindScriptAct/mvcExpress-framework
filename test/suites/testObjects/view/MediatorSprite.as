package suites.testObjects.view {
import flash.display.Sprite;
import flash.events.Event;

import suites.TestViewEvent;

/**
 * COMMENT
 * @author
 */
public class MediatorSprite extends Sprite {

	public var mediator:MediatorSpriteMediator;

	public var child1:MediatorSpriteDispacherChild = new MediatorSpriteDispacherChild();
	public var child2:MediatorSpriteDispacherChild = new MediatorSpriteDispacherChild();

	public function MediatorSprite() {
		this.addChild(child1);
		this.addChild(child2);
	}

	public function tryAddingHandlerTwice():void {
		dispatchEvent(new TestViewEvent(TestViewEvent.TRIGER_ADD_HANDLER));
	}

	public function sendTestEvent():void {
		dispatchEvent(new Event("test"));
	}
}
}