package integration.scopedProxy.testObj.moduleB {
import integration.scopedProxy.ScopedProxyTests;
import integration.scopedProxy.testObj.moduleA.ScopedTestProxy;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ScopedProxyInjectMediator extends Mediator {

	[Inject]
	public var view:ScopedProxyInjectView;

	[Inject(scope="proxyScope")]
	public var myProxy:ScopedTestProxy;

	override protected function onRegister():void {
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

	override protected function onRemove():void {

	}

	public function sendDataToProxy(testData:String):void {
		myProxy.storedData = testData;
	}

}
}