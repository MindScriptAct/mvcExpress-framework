package integration.mediating.testObj.view {
import integration.mediating.testObj.view.viewObj.MediatingBaseView;

import mvcexpress.mvc.Mediator;

public class MediatingSuperClassMediator extends Mediator {

	[Inject]
	public var view:MediatingBaseView;

	//[Inject]
	//public var myProxy:MyProxy;

	override protected function onRegister():void {
		MediatingBaseView.timesRegistered++;
	}

	override protected function onRemove():void {

	}

}
}