package suites.featureRemoteHandlerTests.testObjects.external {
import flash.display.Sprite;
import flash.events.Event;
import suites.ViewTestEvents;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ExternalView extends Sprite {
	
	public function ExternalView() {
	
	}
	
	public function addLocalhandler():void {
		dispatchEvent(new Event(ViewTestEvents.ADD_LOCAL_HANDLER));
	}
	
	public function addRemoteHandler():void {
		dispatchEvent(new Event(ViewTestEvents.ADD_REMOTE_HANDLER));
	}
}
}