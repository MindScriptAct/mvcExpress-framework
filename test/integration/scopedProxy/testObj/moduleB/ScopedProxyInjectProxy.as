package integration.scopedProxy.testObj.moduleB {
import integration.scopedProxy.testObj.moduleA.ScopedTestProxy;

import mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class ScopedProxyInjectProxy extends Proxy {

	[Inject(scope="proxyScope")]
	public var myProxy:ScopedTestProxy;

	public function ScopedProxyInjectProxy() {

	}

	public function storeTestData(testData:String):void {
		myProxy.storedData = testData;
	}

	override protected function onRegister():void {
		trace("ScopedProxyInjectProxy.onRegister");

	}

	override protected function onRemove():void {

	}

}
}