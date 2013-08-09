package integration.scopedMessaging.testObj.moduleB {
import flash.display.Sprite;
import flash.events.Event;

import mvcexpress.extensions.scoped.modules.ModuleScoped;

import mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ChannelModuleB extends ModuleScoped {
	private var view:Sprite;

	static public const NAME:String = "ChannelModuleB";
	public var command1executed:Boolean = false;

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

	public function sendChannelMessage_testChannel_test4_withParams():void {
		view.dispatchEvent(new Event("sendChannelMessage_testChannel_test4_withParams"));
	}

	public function sendChannelMessage_comTest1():void {
		sendScopeMessage("default", "CommTest1", this);
	}

	override protected function onInit():void {
		registerScope("default", true, true, true);
		registerScope("testChannel", true, true, true);
	}

	override protected function onDispose():void {
	}
}
}