package integration.proxyMapMediatorProtectionTests {
import integration.aGenericTestObjects.GenericTestModule;
import integration.aGenericTestObjects.model.GenericTestProxy;
import integration.aGenericTestObjects.model.IGenericTestProxy;
import integration.aGenericTestObjects.view.GenericViewObject;
import integration.aGenericTestObjects.view.GenericViewObjectMediator_withInject;
import integration.aGenericTestObjects.view.GenericViewObjectMediator_withInterfaceInject;

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

	[Test(expects="Error")]

	public function proxyMapMediatorProtection_notMappedProxyInjectedIntoMediator_fails():void {
		var testProxy:GenericTestProxy = new GenericTestProxy();

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}

	[Test(expects="Error")]

	public function proxyMapMediatorProtection_injectAsClassProxyMappedInjectedAsProxyIntoMediator_fails():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy, null, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInject);
	}

	[Test(expects="Error")]
	public function proxyMapMediatorProtection_injectAsMediatorClassProxyMappedInjectedAsProxyIntoMediator_fails():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy, null, null, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInject);
	}

	[Test(expects="Error")]

	public function proxyMapMediatorProtection_injectAsProxyMappedInjectedAsInterfaceIntoMediator_fails():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}


	[Test]

	public function proxyMapMediatorProtection_injectAsClassProxyMappedInjectedAsInterfaceIntoMediator_isOK():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.proxymap_map(testProxy, null, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}

	[Test]
	public function proxyMapMediatorProtection_injectAsMediatorClassProxyMappedInjectedAsInterfaceIntoMediator_isOK():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.proxymap_map(testProxy, null, null, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}


}
}
