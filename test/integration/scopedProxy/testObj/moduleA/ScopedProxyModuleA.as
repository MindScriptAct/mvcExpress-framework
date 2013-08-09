package integration.scopedProxy.testObj.moduleA {
import integration.scopedProxy.ScopedProxyTests;

import mvcexpress.extensions.scoped.modules.ModuleScoped;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ScopedProxyModuleA extends ModuleScoped {
	private var testViewObject:ScopedProxyLocalInjectView;

	static public const NAME:String = "ScopedProxyModuleA";

	public function ScopedProxyModuleA() {
		super(ScopedProxyModuleA.NAME);
	}

	public function hostTestProxy(scopedTestProxy:ScopedTestProxy):void {
		//trace( "ScopedProxyModuleA.hostTestProxy > scopedTestProxy : " + scopedTestProxy );
		registerScope(ScopedProxyTests.SCOPED_PROXY_SCOPE_NAME, true, true, true);
		proxyMapScoped.scopeMap(ScopedProxyTests.SCOPED_PROXY_SCOPE_NAME, scopedTestProxy);
	}

	public function unhostTestProxy(injectClass:Class):void {
		proxyMapScoped.scopeUnmap(ScopedProxyTests.SCOPED_PROXY_SCOPE_NAME, injectClass);
	}

	public function trigerMediatorMessage(testData:String):void {

	}

	public function mapTestProxy(scopedTestProxy:ScopedTestProxy):void {
		proxyMap.map(scopedTestProxy);
	}

	public function createMediatorWithLocalItject():void {
		testViewObject = new ScopedProxyLocalInjectView();

		mediatorMap.map(ScopedProxyLocalInjectView, ScopedProxyLocalInjectMediator);
		mediatorMap.mediate(testViewObject);
	}

	public function getMediatorProxyTestData():void {

	}

	override protected function onInit():void {
		registerScope(ScopedProxyTests.SCOPED_PROXY_SCOPE_NAME, true, true, true);
	}

	override protected function onDispose():void {

	}
}
}