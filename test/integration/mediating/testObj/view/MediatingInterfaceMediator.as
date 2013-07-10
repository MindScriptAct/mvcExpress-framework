package integration.mediating.testObj.view {
import integration.mediating.testObj.view.viewObj.IMediatingIntefrace;
import integration.mediating.testObj.view.viewObj.MediatingBaseView;
import mvcexpress.mvc.Mediator;

public class MediatingInterfaceMediator extends Mediator {

	[Inject]
	public var view:IMediatingIntefrace;

	//[Inject]
	//public var myProxy:MyProxy;

	override public function onRegister():void {
		MediatingBaseView.timesRegistered++;
	}

	override public function onRemove():void {

	}

}
}