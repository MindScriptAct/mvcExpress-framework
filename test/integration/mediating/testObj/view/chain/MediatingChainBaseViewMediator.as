package integration.mediating.testObj.view.chain {
import integration.mediating.MediatingTestingVars;
import integration.mediating.testObj.view.viewObj.MediatingBaseView;

import mvcexpress.mvc.Mediator;

public class MediatingChainBaseViewMediator extends Mediator {

	[Inject]
	public var view:MediatingBaseView;

	//[Inject]
	//public var myProxy:MyProxy;

	override protected function onRegister():void {
		MediatingTestingVars.timesRegistered++;
		MediatingTestingVars.viewObject = view;
	}

	override protected function onRemove():void {

	}

}
}