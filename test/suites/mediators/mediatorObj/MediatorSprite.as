package suites.mediators.mediatorObj {
import flash.display.Sprite;
import flash.events.Event;
import suites.ViewTestEvents;

/**
 * COMMENT
 * @author
 */
public class MediatorSprite extends Sprite {
	
	public function MediatorSprite() {
	
	}
	
	public function tryAddingHandlerTwice():void {
		dispatchEvent(new Event(ViewTestEvents.TRIGER_ADD_HANDLER));
	}

}
}