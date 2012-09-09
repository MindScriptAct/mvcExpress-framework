package integration.channeling.testObj.moduleB {
import flash.display.Sprite;
import flash.events.Event;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ChannelModuleB extends ModuleCore {
	private var view:Sprite;
	
	static public const NAME:String = "ChannelModuleB";
	
	public function ChannelModuleB() {
		super(ChannelModuleB.NAME);
	}
	
	public function cheateTestMediator():void {
		mediatorMap.map(Sprite, ChannelBMediator);
		view = new Sprite();
		mediatorMap.mediate(view);
	}
	
	public function sendChannelMessage_test1():void {
		view.dispatchEvent(new Event("sendChannelMessage_test1"));
	}
	
	public function sendChannelMessage_test2():void {
		view.dispatchEvent(new Event("sendChannelMessage_test2"));
	}
	
	public function sendChannelMessage_testChannel_test3():void {
		view.dispatchEvent(new Event("sendChannelMessage_testChannel_test3"));
	}
	
	override protected function onInit():void {
	
	}
	
	override protected function onDispose():void {
	
	}
}
}