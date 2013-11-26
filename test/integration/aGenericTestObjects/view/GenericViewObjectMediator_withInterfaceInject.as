package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.model.IGenericTestProxy;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_withInterfaceInject extends Mediator {

	[Inject]
	public var view:GenericViewObject;

	[Inject]
	public var genericTestProxy:IGenericTestProxy;

	override protected function onRegister():void {

	}

	override protected function onRemove():void {

	}

}
}