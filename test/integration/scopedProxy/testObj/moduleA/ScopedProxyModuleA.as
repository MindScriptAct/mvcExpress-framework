package integration.scopedProxy.testObj.moduleA {
import flash.display.Sprite;
import flash.events.Event;
import integration.scopedProxy.ScopedProxyTests;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ScopedProxyModuleA extends ModuleCore {
	private var testViewObject:ScopedProxyLocalInjectView;
	
	static public const NAME:String = "ScopedProxyModuleA";
	
	public function ScopedProxyModuleA() {
		super(ScopedProxyModuleA.NAME);
	}
	
	public function hostTestProxy(scopedTestProxy:ScopedTestProxy):void {
		//trace( "ScopedProxyModuleA.hostTestProxy > scopedTestProxy : " + scopedTestProxy );
		proxyMap.scopeMap(ScopedProxyTests.SCOPED_PROXY_SCOPE_NAME, scopedTestProxy);
	}
	
	public function unhostTestProxy(injectClass:Class):void {
		proxyMap.scopeUnmap(ScopedProxyTests.SCOPED_PROXY_SCOPE_NAME, injectClass);
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
	
	}
	
	override protected function onDispose():void {
	
	}
}
}