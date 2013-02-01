package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.constants.GenericScopeIds;
import integration.aGenericTestObjects.constants.GenericTestMessage;
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_handlingScopeMessage extends Mediator {
	
	[Inject]
	public var view:GenericViewObject;
	
	override public function onRegister():void {
		addScopeHandler(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE, handleTestMessage);
	}
	
	private function handleTestMessage(blank:Object):void {
	
	}
	
	override public function onRemove():void {
	
	}

}
}