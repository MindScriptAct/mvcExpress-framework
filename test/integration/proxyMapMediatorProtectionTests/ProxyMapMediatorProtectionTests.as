package integration.proxyMapMediatorProtectionTests {
import integration.aGenericTestObjects.GenericTestModule;
import integration.aGenericTestObjects.model.GenericTestProxy;
import integration.aGenericTestObjects.model.IGenericTestProxy;
import integration.proxyMap.testObj.TestConstObject;

public class ProxyMapMediatorProtectionTests {
	private var module:GenericTestModule;

	[Before]

	public function runBeforeEveryTest():void {
		module = new GenericTestModule("ProxyMapMediatorProtection_test");
	}

	[After]

	public function runAfterEveryTest():void {
		module.disposeModule();
	}

	//----------------------------------
	//
	//----------------------------------

	[Test]

	public function proxyMapMediatorProtection_injectIntoProxyConstNamedVariable_injectedOk():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.proxymap_map(testProxy, null, "", IGenericTestProxy);
	}
}
}
