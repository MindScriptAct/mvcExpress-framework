package suites.featureProxyHost.testObjects.localObjects {
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class HostViewTestMediator extends Mediator {
	
	[Inject]
	public var view:HostViewTest;
	
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