package integration.scopedProxy.testObj.moduleA {
import integration.scopedProxy.ScopedProxyTests;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class ScopedProxyLocalInjectMediator extends Mediator {

	[Inject]
	public var view:ScopedProxyLocalInjectView;

	[Inject]
	public var myProxy:ScopedTestProxy;

	override protected function onRegister():void {
		trace("ScopedProxyInjectMediator.onRegister");
		view.pushMediatorIn(this);
		//ScopedProxyModuleB.TEST_FUNCTION(null);

		addHandler(ScopedProxyTests.SCOPED_PROXY_MESSAGE_NAME, handleScopedMessage);
	}

	private function handleScopedMessage(testdata:String):void {
		trace("ScopedProxyInjectMediator.handleScopedMessage > testdata : " + testdata);
		myProxy.storedData = testdata;
	}

	override protected function onRemove():void {

	}

	public function sendDataToProxy(testData:String):void {
		myProxy.storedData = testData;
	}

}
}