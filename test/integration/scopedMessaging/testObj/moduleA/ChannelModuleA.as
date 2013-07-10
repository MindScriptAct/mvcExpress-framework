package integration.scopedMessaging.testObj.moduleA {
import flash.events.Event;

import mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ChannelModuleA extends ModuleCore {
	public var view:ChannelViewA;

	static public const NAME:String = "ChannelModuleA";

	public function ChannelModuleA() {
		super(ChannelModuleA.NAME);
	}

	public function cheateTestMediator():void {
		mediatorMap.map(ChannelViewA, ChannelAMediator);
		view = new ChannelViewA();
		mediatorMap.mediate(view);
	}

	public function addChannelHandler_test1():void {
		view.dispatchEvent(new Event("addChannelHandler_test1"));
	}

	public function removeChannelHandler_test1():void {
		view.dispatchEvent(new Event("removeChannelHandler_test1"));
	}

	public function addChannelHandler_test2():void {
		view.dispatchEvent(new Event("addChannelHandler_test2"));
	}

	public function addChannelHandler_testChannel_test3():void {
		view.dispatchEvent(new Event("addChannelHandler_testChannel_test3"));
	}

	public function addChannelHandler_testChannel_test4_withParams():void {
		view.dispatchEvent(new Event("addChannelHandler_testChannel_test4_withParams"));
	}

	public function mapCommand_ComTest1():void {
		commandMap.scopeMap("default", "CommTest1", ComTest1Command);
	}

	public function unmapCommand_ComTest1():void {
		commandMap.scopeUnmap("default", "CommTest1", ComTest1Command);
	}

	override protected function onInit():void {
		registerScope("default", true, true, true);
		registerScope("testChannel", true, true, true);
	}

	override protected function onDispose():void {

	}
}
}