package integration.mediating.testObj.view.chain {
import integration.mediating.testObj.view.viewObj.MediatingView;

public class MediatingChainViewMediator extends MediatingChainBaseViewMediator {

	[Inject]
	public var extendedView:MediatingView;

	//[Inject]
	//public var myProxy:MyProxy;

	override protected function onRegister():void {
		super.onRegister();
	}

	override protected function onRemove():void {

	}

}
}