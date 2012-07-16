package suites.featureRemoteHandlerTests.testObjects.main {
import flash.display.Sprite;
import flash.events.Event;
import suites.ViewTestEvents;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MainView extends Sprite {
	
	public function MainView() {
	
	}
	
	public function addLocalhandler():void {
		dispatchEvent(new Event(ViewTestEvents.ADD_LOCAL_HANDLER));
	}
	
	public function addRemoteHandler():void {
		dispatchEvent(new Event(ViewTestEvents.ADD_REMOTE_HANDLER));
	}

}
}