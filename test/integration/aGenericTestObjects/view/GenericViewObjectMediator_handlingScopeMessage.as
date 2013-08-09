package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.constants.GenericScopeIds;
import integration.aGenericTestObjects.constants.GenericTestMessage;

import mvcexpress.extensions.scoped.mvc.MediatorScoped;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_handlingScopeMessage extends MediatorScoped {

	[Inject]
	public var view:GenericViewObject;

	override protected function onRegister():void {
		addScopeHandler(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE, handleTestMessage);
	}

	private function handleTestMessage(blank:Object):void {

	}

	override protected function onRemove():void {

	}

}
}