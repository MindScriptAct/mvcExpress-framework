package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.constants.GenericTestMessage;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_handlingMessage extends Mediator {

	[Inject]
	public var view:GenericViewObject;

	override protected function onRegister():void {
		addHandler(GenericTestMessage.TEST_MESSAGE, handleTestMessage);
	}

	private function handleTestMessage(blank:Object):void {

	}

	override protected function onRemove():void {

	}

}
}