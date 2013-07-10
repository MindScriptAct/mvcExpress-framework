package integration.aGenericTestObjects.view {
import integration.aGenericTestObjects.model.GenericTestProxy;
import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator_withInject extends Mediator{

	[Inject]
	public var view:GenericViewObject;

	[Inject]
	public var genericTestProxy:GenericTestProxy;

	override public function onRegister():void{

	}

	override public function onRemove():void{

	}

}
}