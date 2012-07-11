package suites.featureProxyHost.testObjects.remoteModule {
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class RemoteViewTestMediator extends Mediator {
	
	[Inject]
	public var view:RemoteViewTest;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		addHandler("proxyCommunicationTest", handleTestMessage);
	}
	
	private function handleTestMessage(blank:Object):void {
		view.messageReached = true;
	}
	
	override public function onRemove():void {
	
	}

}
}