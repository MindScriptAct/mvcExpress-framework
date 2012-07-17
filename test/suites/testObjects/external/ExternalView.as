package suites.testObjects.external {
import flash.display.Sprite;
import flash.events.Event;
import suites.TestViewEvent;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ExternalView extends Sprite {
	
	public function ExternalView() {
	
	}
	
	public function addLocalhandler(message:String):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.ADD_LOCAL_HANDLER, message));
	}
	
	public function addRemoteHandler(message:String):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.ADD_REMOTE_HANDLER, message));
	}
	
	public function removeLocalhandler(message:String):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.REMOVE_LOCAL_HANDLER, message));
	}
	
	public function removeRemoteHandler(message:String):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.REMOVE_REMOTE_HANDLER, message));
	}
}
}