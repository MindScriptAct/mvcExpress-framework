package suites.testObjects.view {
import flash.display.Sprite;
import flash.events.Event;
import suites.TestViewEvent;

/**
 * COMMENT
 * @author
 */
public class MediatorSprite extends Sprite {
	
	public function MediatorSprite() {
	
	}
	
	public function tryAddingHandlerTwice():void {
		dispatchEvent(new TestViewEvent(TestViewEvent.TRIGER_ADD_HANDLER));
	}

}
}