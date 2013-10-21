package suites.testObjects.moduleMain {
import flash.display.Sprite;

import suites.TestViewEvent;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class MainView extends Sprite {

	public function MainView() {
	}

	public function addLocalhandler(message:String):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.ADD_LOCAL_HANDLER, message));
	}

	public function addRemoteHandler(message:String):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.ADD_REMOTE_HANDLER, message));
	}

	public function removeLocalhandler(message:String):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.REMOVE_LOCAL_HANDLER, message));
	}

	public function removeRemoteHandler(message:String):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.REMOVE_REMOTE_HANDLER, message));
	}

	public function testGetProxyClass(proxyClass:Class, name:String = ""):void {
		dispatchEvent(new TestViewEvent(TestViewEvent.TEST_GET_PROXY_CLASS, name, proxyClass));
	}

}
}