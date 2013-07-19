package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.constants.GenericTestMessage;
import integration.aGenericTestObjects.view.event.ViewTestEvent;
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_handlingListener extends Mediator {
	
	[Inject]
	public var view:GenericViewObject;
	
	override public function onRegister():void {
		addListener(view, ViewTestEvent.VIEW_TEST_BLANK, handlTestBlankEvent);
		addListener(view, ViewTestEvent.VIEW_TEST_SENDS_MESSAGE, handlTestSendMessageEvent);
	}
	
	private function handlTestBlankEvent(event:ViewTestEvent):void {
	}
	
	private function handlTestSendMessageEvent(event:ViewTestEvent):void {
		sendMessage(GenericTestMessage.TEST_MESSAGE);
	}
	
	override public function onRemove():void {
	
	}

}
}