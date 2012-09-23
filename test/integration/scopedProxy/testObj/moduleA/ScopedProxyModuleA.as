package integration.scopedProxy.testObj.moduleA {
import flash.display.Sprite;
import flash.events.Event;
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
	
	override protected function onInit():void {
	
	}
	
	override protected function onDispose():void {
	
	}
}
}