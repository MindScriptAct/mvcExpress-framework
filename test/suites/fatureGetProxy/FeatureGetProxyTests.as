package suites.fatureGetProxy {
import flexunit.framework.Assert;

import suites.testObjects.model.ISimpleTestProxy;
import suites.testObjects.model.SimpleTestProxy;
import suites.testObjects.moduleMain.MainModule;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class FeatureGetProxyTests {

	private var mainModule:MainModule;
	//private var externalModule:ExternalModule;

	[Before]

	public function runBeforeEveryTest():void {
		mainModule = new MainModule();
		//externalModule = new ExternalModule();
	}

	[After]

	public function runAfterEveryTest():void {
		mainModule.disposeModule();
		//externalModule.disposeModule();
	}

	//----------------------------------
	//     Get simple proxy
	//----------------------------------

	[Test(description=" get proxy in proxy")]

	public function featureGetProxy_get_proxy_in_proxy():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy);
		var returnedObj:Object = mainModule.getProxyFromProxy(SimpleTestProxy);
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from other proxies.", testProxy, returnedObj);
	}

	[Test(description=" get proxy in mediator", expects="Error")]

	public function featureGetProxy_get_proxy_in_mediator_fails():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy);
		var returnedObj:Object = mainModule.getProxyFromMediator(SimpleTestProxy);
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from mediators.", testProxy, returnedObj);
	}


	[Test(description=" get proxy in command")]

	public function featureGetProxy_get_proxy_in_command():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy);
		var returnedObj:Object = mainModule.getProxyInCommand(SimpleTestProxy);
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from mediators.", testProxy, returnedObj);

	}

	[Test(description=" get proxy in module")]

	public function featureGetProxy_get_proxy_in_module():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy);
		var returnedObj:Object = mainModule.getTestProxy(SimpleTestProxy);
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from modules.", testProxy, returnedObj);
	}

	//----------------------------------
	//     Get interfaced proxy
	//----------------------------------

	[Test(description=" get proxy interface in proxy")]

	public function featureGetProxy_get_proxy_interfaced_in_proxy():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, null, ISimpleTestProxy);
		var returnedObj:Object = mainModule.getProxyFromProxy(ISimpleTestProxy);
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from other proxies.", testProxy, returnedObj);
	}

	[Test(description=" get proxy interface in mediator", expects="Error")]

	public function featureGetProxy_get_proxy_interfaced_in_mediator_fails():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, null, ISimpleTestProxy);
		var returnedObj:Object = mainModule.getProxyFromMediator(ISimpleTestProxy);
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from mediators.", testProxy, returnedObj);
	}

	[Test(description=" get proxy interface in mediator", expects="Error")]

	public function featureGetProxy_get_proxy_interfaced_in_mediator():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, null, ISimpleTestProxy, ISimpleTestProxy);
		var returnedObj:Object = mainModule.getProxyFromMediator(ISimpleTestProxy);
		Assert.assertStrictlyEquals("You should be able to get mapped proxies from mediators.", testProxy, returnedObj);
	}

	[Test(description=" get proxy interface in command")]

	public function featureGetProxy_get_proxy_interfaced_in_command():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, null, ISimpleTestProxy);
		var returnedObj:Object = mainModule.getProxyInCommand(ISimpleTestProxy);
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from mediators.", testProxy, returnedObj);

	}

	[Test(description=" get proxy interfaced and named in module")]

	public function featureGetProxy_get_proxy_interfaced_in_module():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, null, ISimpleTestProxy);
		var returnedObj:Object = mainModule.getTestProxy(ISimpleTestProxy);
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from modules.", testProxy, returnedObj);
	}

	//----------------------------------
	//     Get interfaced and named proxy
	//----------------------------------

	[Test(description=" get proxy interfaced and named in proxy")]

	public function featureGetProxy_get_proxy_interfaced_named_in_proxy():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, "testName", ISimpleTestProxy);
		var returnedObj:Object = mainModule.getProxyFromProxy(ISimpleTestProxy, "testName");
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from other proxies.", testProxy, returnedObj);
	}

	[Test(description=" get proxy interfaced and named in mediator", expects="Error")]

	public function featureGetProxy_get_proxy_interfaced_named_in_mediator_fails():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, "testName", ISimpleTestProxy);
		var returnedObj:Object = mainModule.getProxyFromMediator(ISimpleTestProxy, "testName");
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from mediators.", testProxy, returnedObj);
	}

	[Test(description=" get proxy interfaced and named in mediator", expects="Error")]

	public function featureGetProxy_get_proxy_interfaced_named_in_mediator_ok():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, "testName", ISimpleTestProxy, ISimpleTestProxy);
		var returnedObj:Object = mainModule.getProxyFromMediator(ISimpleTestProxy, "testName");
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from mediators.", testProxy, returnedObj);
	}

	[Test(description=" get proxy interfaced and named in command")]

	public function featureGetProxy_get_proxy_interfaced_named_in_command():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, "testName", ISimpleTestProxy);
		var returnedObj:Object = mainModule.getProxyInCommand(ISimpleTestProxy, "testName");
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from mediators.", testProxy, returnedObj);

	}

	[Test(description=" get proxy interfaced and named in module")]

	public function featureGetProxy_get_proxy_interfaced_named_in_module():void {
		var testProxy:SimpleTestProxy = new SimpleTestProxy();
		mainModule.mapTestProxy(testProxy, "testName", ISimpleTestProxy);
		var returnedObj:Object = mainModule.getTestProxy(ISimpleTestProxy, "testName");
		Assert.assertStrictlyEquals("You should be abble to get mapped proxies from modules.", testProxy, returnedObj);
	}
}
}