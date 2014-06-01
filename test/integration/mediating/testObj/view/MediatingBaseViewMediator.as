package integration.mediating.testObj.view {
import integration.mediating.MediatingTestingVars;
import integration.mediating.testObj.view.viewObj.MediatingBaseView;

import mvcexpress.mvc.Mediator;

public class MediatingBaseViewMediator extends Mediator {

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