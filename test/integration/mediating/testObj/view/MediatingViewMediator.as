package integration.mediating.testObj.view {
import integration.mediating.MediatingTestingVars;
import integration.mediating.testObj.view.viewObj.MediatingView;

import mvcexpress.mvc.Mediator;

public class MediatingViewMediator extends Mediator {

	[Inject]
	public var view:MediatingView;

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