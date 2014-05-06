package suites.testObjects.view {
import flash.display.Sprite;

import mvcexpress.mvc.Mediator;

import suites.TestViewEvent;

/**
 * COMMENT
 * @author
 */
public class MediatorSprite extends Sprite {

	public var mediator:MediatorSpriteMediator;

	public function MediatorSprite() {

	}

	public function tryAddingHandlerTwice():void {
		dispatchEvent(new TestViewEvent(TestViewEvent.TRIGER_ADD_HANDLER));
	}

}
}