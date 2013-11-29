package integration.proxyMap {
import integration.aGenericTestObjects.GenericTestModule;
import integration.aGenericTestObjects.constants.GenericTestMessage;
import integration.aGenericTestObjects.model.GenericTestProxy;
import integration.proxyMap.testObj.TestConstCommand;
import integration.proxyMap.testObj.TestConstObject;
import integration.proxyMap.testObj.TestContsView;
import integration.proxyMap.testObj.TestContsViewMediator;
import integration.proxyMap.testObj.TestProxyInjectFromProxyCommand;
import integration.proxyMap.testObj.TestWithConstNameInjectProxy;

/**
 * COMMENT
 * @author rBanevicius
 */
public class ProxyMapTests {
	private var module:GenericTestModule;

	[Before]

	public function runBeforeEveryTest():void {
		module = new GenericTestModule("ProxyMap_test");
	}

	[After]

	public function runAfterEveryTest():void {
		module.disposeModule();
	}

	//----------------------------------
	//
	//----------------------------------

	[Test]

	public function proxyMap_injectIntoProxyConstNamedVariable_injectedOk():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		module.proxymap_map(new TestWithConstNameInjectProxy());
	}

	[Test(expects="Error")]

	public function proxyMap_injectIntoMediatorConstNamedVariable_fails():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		module.mediatorMap_mediateWith(new TestContsView(), TestContsViewMediator);
	}

	[Test]

	public function proxyMap_injectIntoMediatorConstNamedVariable_injectedOk():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy, TestConstObject.TEST_CONST_FOR_PROXY_INJECT, null, GenericTestProxy);
		//
		module.mediatorMap_mediateWith(new TestContsView(), TestContsViewMediator);
	}

	[Test]

	public function proxyMap_injectIntoCommandConstNamedVariable_injectedOk():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		//module.mapProxy(new TexsWithConstNameInjectProxy());
		module.commandMap_execute(TestConstCommand)
	}


	[Test]

	public function proxyMap_injectIntoProxyRegisterTriggeredCommandSameProxy_injectedOk():void {

		module.commandMap_map(GenericTestMessage.TEST_MESSAGE, TestProxyInjectFromProxyCommand);

		var testProxy:GenericTestProxy = new GenericTestProxy(GenericTestMessage.TEST_MESSAGE);

		module.proxymap_map(testProxy);

	}


}
}