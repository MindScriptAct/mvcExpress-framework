package integration.aGenericTestObjects.view {
import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator extends Mediator {

	[Inject]
	public var view:GenericViewObject;

	//[Inject]
	//public var myProxy:MyProxy;

	override protected function onRegister():void {

	}

	override protected function onRemove():void {

	}

}
}