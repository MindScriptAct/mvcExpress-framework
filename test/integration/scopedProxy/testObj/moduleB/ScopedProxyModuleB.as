package integration.scopedProxy.testObj.moduleB {
import flash.display.Sprite;
import flash.events.Event;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ScopedProxyModuleB extends ModuleCore {
	private var view:Sprite;
	
	static public const NAME:String = "ScopedProxyModuleB";
	
	public function ScopedProxyModuleB() {
		super(ScopedProxyModuleB.NAME);
	}
	
	override protected function onInit():void {
	
	}
	
	override protected function onDispose():void {
	
	}
}
}