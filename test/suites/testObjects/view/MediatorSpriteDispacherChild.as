package suites.testObjects.view {
import flash.display.Sprite;
import flash.events.Event;

public class MediatorSpriteDispacherChild extends Sprite {

	public function MediatorSpriteDispacherChild() {

	}

	public function sendTestEvent():void {
		dispatchEvent(new Event("test"));
	}
}
}
