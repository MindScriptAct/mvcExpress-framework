package integration.lazyProxy.testObj.moduleA {
import flash.display.Sprite;
import flash.events.Event;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class LazyProxyModuleA extends ModuleCore {	
	static public const NAME:String = "LazyProxyModuleA";
	
	public function LazyProxyModuleA() {
		super(LazyProxyModuleA.NAME);
	}
	
	public function lazyMap():void {
		proxyMap.lazyMap(LazyProxy);
	}
	
	public function createProxyWithLazyInject():void {
		proxyMap.map(new LazyNormalProxy());
	}
	
}
}