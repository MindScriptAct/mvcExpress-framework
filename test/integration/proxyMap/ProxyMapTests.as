package integration.proxyMap {
import flash.display.Sprite;
import integration.aGenericTestObjects.genericObjects.GenericTestProxy;
import integration.aGenericTestObjects.GenericTestModule;
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
		module.mapProxy(testProxy, null, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		module.mapProxy(new TexsWithConstNameInjectProxy());
	}
	
	[Test]
	
	public function proxyMap_injectIntoMediatorConstNamedVariable_injectedOk():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.mapProxy(testProxy, null, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		module.mapMediatorWith(new TestContsView(), TestContsViewMediator);
	}
	
	[Test]
	
	public function proxyMap_injectIntoCommandConstNamedVariable_injectedOk():void {
		var testProxy:GenericTestProxy = new GenericTestProxy()
		module.mapProxy(testProxy, null, TestConstObject.TEST_CONST_FOR_PROXY_INJECT);
		//
		//module.mapProxy(new TexsWithConstNameInjectProxy());
		module.execute(CestConstCommand)
	}	
	
	
}
}