package integration.proxyMap {
import flash.display.Sprite;
import integration.aGenericTestObjects.GenericTestModule;
import integration.aGenericTestObjects.model.GenericTestProxy;
import integration.proxyMap.testObj.CestConstCommand;
import integration.proxyMap.testObj.TestConstObject;
import integration.proxyMap.testObj.TestContsView;
import integration.proxyMap.testObj.TestContsViewMediator;
import integration.proxyMap.testObj.TexsWithConstNameInjectProxy;

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
		module.proxymap_map(testProxy, null, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		module.proxymap_map(new TexsWithConstNameInjectProxy());
	}
	
	[Test]
	
	public function proxyMap_injectIntoMediatorConstNamedVariable_injectedOk():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy, null, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		module.mediatorMap_mediateWith(new TestContsView(), TestContsViewMediator);
	}
	
	[Test]
	
	public function proxyMap_injectIntoCommandConstNamedVariable_injectedOk():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.proxymap_map(testProxy, null, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		//module.mapProxy(new TexsWithConstNameInjectProxy());
		module.commandMap_execute(CestConstCommand)
	}	
	
	
}
}