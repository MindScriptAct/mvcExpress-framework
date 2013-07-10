package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.model.GenericTestProxy;
import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_withScopedInject extends Mediator {

	[Inject]
	public var view:GenericViewObject;

	[Inject(scope="GenericScopeIds_testScope")]
	public var genericTestProxy:GenericTestProxy;

	override public function onRegister():void {
		trace( "GenericViewObjectMediator_withScopedInject.onRegister" );

	}

	override public function onRemove():void {

	}

}
}