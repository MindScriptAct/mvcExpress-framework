package integration.mediating.testObj.view.chain {
import integration.mediating.testObj.view.viewObj.IMediatingView;

public class MediatingChainIViewMediator extends MediatingChainBaseViewMediator {

	[Inject]
	public var view:IMediatingView;

	//[Inject]
	//public var myProxy:MyProxy;

	override protected function onRegister():void {
	}

	override protected function onRemove():void {

	}

}
}