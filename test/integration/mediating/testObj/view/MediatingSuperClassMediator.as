package integration.mediating.testObj.view{
import integration.mediating.testObj.view.viewObj.MediatingBaseView;
import org.mvcexpress.mvc.Mediator;

public class MediatingSuperClassMediator extends Mediator {
	
	[Inject]
	public var view:MediatingBaseView;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		MediatingBaseView.timesRegistered++;
	}
	
	override public function onRemove():void {
		
	}
	
}
}