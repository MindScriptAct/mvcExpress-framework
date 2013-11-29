package integration.proxyMapMediatorProtectionTests {
import integration.aGenericTestObjects.GenericTestModule;
import integration.aGenericTestObjects.model.GenericTestProxy;
import integration.aGenericTestObjects.model.IGenericTestProxy;
import integration.aGenericTestObjects.view.GenericViewObject;
import integration.aGenericTestObjects.view.GenericViewObjectMediator_withInject;
import integration.aGenericTestObjects.view.GenericViewObjectMediator_withInterfaceInject;

import mvcexpress.MvcExpress;

import org.flexunit.Assert;

import utils.AsyncUtil;

public class ProxyMapMediatorProtectionTests {
	private var module:GenericTestModule;

	[Before]
	public function runBeforeEveryTest():void {
		module = new GenericTestModule("ProxyMapMediatorProtection_test");
	}

	[After]
	public function runAfterEveryTest():void {
		MvcExpress.pendingInjectsTimeOut = 0;
		module.disposeModule();
	}

	//----------------------------------
	// should fail
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

	//----------------------------------
	// should work ok, simple proxy injected into mediator as interface.
	//----------------------------------

	[Test(expects="Error")]
	public function proxyMapMediatorProtection_injectAsClassProxyMappedInjectedAsInterfaceIntoMediator_fails():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.proxymap_map(testProxy, null, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}

	[Test]
	public function proxyMapMediatorProtection_injectAsMediatorAndInjectClassProxyMappedInjectedAsInterfaceIntoMediator_isOK():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.proxymap_map(testProxy, null, IGenericTestProxy, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}

	[Test]
	public function proxyMapMediatorProtection_injectAsMediatorClassProxyMappedInjectedAsInterfaceIntoMediator_isOK():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.proxymap_map(testProxy, null, null, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}

	//----------------------------------
	// should work ok, pending proxy injected into mediator as interface.
	//----------------------------------

	[Test(async, expects="Error")]
	public function proxyMapMediatorProtection_pendingInjectAsClassProxyMappedInjectedAsInterfaceIntoMediator_fails():void {
		GenericViewObjectMediator_withInterfaceInject.ASYNC_REGISTER_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 200, callBackFail);

		MvcExpress.pendingInjectsTimeOut = 500;
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);

		module.proxymap_map(testProxy, null, IGenericTestProxy);

	}

	[Test(async)]
	public function proxyMapMediatorProtection_pendingInjectAsClassProxyMappedInjectedAsMediatorInterfaceIntoMediator_isOK():void {
		GenericViewObjectMediator_withInterfaceInject.ASYNC_REGISTER_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 200, callBackFail);

		MvcExpress.pendingInjectsTimeOut = 500;
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);

		module.proxymap_map(testProxy, null, null, IGenericTestProxy);

	}

	[Test(async)]
	public function proxyMapMediatorProtection_pendingInjectAsMediatorClassProxyMappedInjectedAsInterfaceIntoMediator_fails():void {

		GenericViewObjectMediator_withInterfaceInject.ASYNC_REGISTER_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 200, callBackFail);

		MvcExpress.pendingInjectsTimeOut = 500;
		var testProxy:GenericTestProxy = new GenericTestProxy()
		//
		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);

		module.proxymap_map(testProxy, null, null, IGenericTestProxy);

	}

	//----------------------------------
	// should work ok, lazy proxy injected into mediator as interface.
	//----------------------------------

	[Test(expects="Error")]
	public function proxyMapMediatorProtection_lazyInjectAsClassProxyMappedInjectedAsInterfaceIntoMediator_fails():void {
		//
		module.proxymap_lazyMap(GenericTestProxy, null, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}

	[Test]
	public function proxyMapMediatorProtection_lazyInjectAsMediatorClassProxyMappedInjectedAsInterfaceIntoMediator_isOK():void {
		//
		module.proxymap_lazyMap(GenericTestProxy, null, null, IGenericTestProxy);

		module.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withInterfaceInject);
	}

	//----------------------------------
	//
	//----------------------------------
	private function callBackFail(obj:* = null):void {
		GenericViewObjectMediator_withInterfaceInject.ASYNC_REGISTER_FUNCTION = null;
		Assert.fail("CallBack should not be called...");
	}

	public function callBackSuccess(obj:* = null):void {
		GenericViewObjectMediator_withInterfaceInject.ASYNC_REGISTER_FUNCTION = null;
	}


}
}
