package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.model.GenericTestProxy;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_withInject extends Mediator {

	[Inject]
	public var view:GenericViewObject;

	[Inject]
	public var genericTestProxy:GenericTestProxy;

	public static var ASYNC_REGISTER_FUNCTION:Function;

	override protected function onRegister():void {
		if (ASYNC_REGISTER_FUNCTION != null) {
			ASYNC_REGISTER_FUNCTION();
		}
	}

	override protected function onRemove():void {

	}

}
}