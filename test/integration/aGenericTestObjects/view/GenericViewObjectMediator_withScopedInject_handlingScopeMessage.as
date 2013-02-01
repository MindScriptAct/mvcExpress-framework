package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.constants.GenericScopeIds;
import integration.aGenericTestObjects.constants.GenericTestMessage;
import integration.aGenericTestObjects.constants.GenericTestStrings;
import integration.aGenericTestObjects.model.GenericTestProxy;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_withScopedInject_handlingScopeMessage extends Mediator {
	
	[Inject]
	public var view:GenericViewObject;
	
	[Inject(scope="GenericScopeIds_testScope")]
	public var genericTestProxy:GenericTestProxy;
	
	override public function onRegister():void {
		trace("GenericViewObjectMediator_withScopedInject.onRegister");
		
		addScopeHandler(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE, handleTestMessage);
	
	}
	
	private function handleTestMessage(blank:Object):void {
		trace("GenericViewObjectMediator_withScopedInject_handlingScopeMessage.handleTestMessage > blank : " + blank);
		genericTestProxy.testData = GenericTestStrings.data1;
	}
	
	override public function onRemove():void {
	
	}

}
}