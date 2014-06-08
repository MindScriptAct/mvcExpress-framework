package integration.mediating.testObj.view {
import integration.mediating.MediatingTestingVars;
import integration.mediating.testObj.view.viewObj.IMediatingView;

import mvcexpress.mvc.Mediator;

public class MediatingIViewMediator extends Mediator {

	[Inject]
	public var view:IMediatingView;

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