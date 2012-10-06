package integration.scopedProxy.testObj.moduleA {
import flash.display.Sprite;
import flash.events.Event;
import integration.scopedProxy.ScoppedProxyConstants;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ScopedProxyModuleA extends ModuleCore {
	
	static public const NAME:String = "ScopedProxyModuleA";
	
	public function ScopedProxyModuleA() {
		super(ScopedProxyModuleA.NAME);
	}
	
	public function hostTestProxy(scopedTestProxy:ScopedTestProxy):void {
		proxyMap.scopeMap(ScoppedProxyConstants.PROXY_SCOPE, scopedTestProxy);
	}
	
	public function unhostTestProxy():void {
	
	}
	
	public function trigerMediatorMessage(testData:String):void {
	
	}
	
	override protected function onInit():void {
	
	}
	
	override protected function onDispose():void {
	
	}
}
}