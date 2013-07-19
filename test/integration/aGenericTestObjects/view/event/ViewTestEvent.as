package integration.aGenericTestObjects.view.event {
import flash.events.Event;

/**
 * ...
 * @author Deril
 */
public class ViewTestEvent extends Event {
	
	static public const VIEW_TEST_BLANK:String = "ViewTest_BLANK";
	static public const VIEW_TEST_SENDS_MESSAGE:String = "ViewTest_SENDS_MESSAGE";
	
	public function ViewTestEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}
	
	public override function clone():Event {
		return new ViewTestEvent(type, bubbles, cancelable);
	}
	
	public override function toString():String {
		return formatToString("ViewTestEvent", "type", "bubbles", "cancelable", "eventPhase");
	}

}

}