package integration.scopedProxy.testObj.moduleB {
import flash.display.Sprite;
import integration.scopedProxy.ScopedProxyTests;
import integration.scopedProxy.testObj.moduleA.ScopedTestProxy;
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ScopedProxyInjectMediator extends Mediator {
	
	[Inject]
	public var view:ScopedProxyInjectView;
	
	[Inject(scope="proxyScope")]
	public var myProxy:ScopedTestProxy;
	
	override public function onRegister():void {
		trace("ScopedProxyInjectMediator.onRegister");
		view.pushMediatorIn(this);
		ScopedProxyModuleB.TEST_FUNCTION(null);
		
		addScopeHandler(ScopedProxyTests.SCOPED_PROXY_SCOPE_NAME, ScopedProxyTests.SCOPED_PROXY_MESSAGE_NAME, handleScopedMessage);
	}
	
	private function handleScopedMessage(testdata:String):void {
		trace("ScopedProxyInjectMediator.handleScopedMessage > testdata : " + testdata);
		myProxy.storedData = testdata;
		view.testData = testdata;
	}
	
	override public function onRemove():void {
	
	}
	
	public function sendDataToProxy(testData:String):void {
		myProxy.storedData = testData;
	}

}
}