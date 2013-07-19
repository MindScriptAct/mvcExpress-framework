package integration.aGenericTestObjects.view {
import flash.display.Sprite;
import integration.aGenericTestObjects.view.event.ViewTestEvent;

public class GenericViewObject extends Sprite {
	
	public function GenericViewObject() {
	}
	
	public function dispatchTestBlankEvent():void {
		dispatchEvent(new ViewTestEvent(ViewTestEvent.VIEW_TEST_BLANK));
	}
	
	
	public function dispatchTestTrigerMessagEvent():void {
		dispatchEvent(new ViewTestEvent(ViewTestEvent.VIEW_TEST_SENDS_MESSAGE));
	}	
}
}