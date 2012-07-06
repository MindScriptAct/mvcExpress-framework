package suites.mediators {
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.messenger.MessengerManager;
import org.mvcexpress.namespace.pureLegsCore;
import suites.mediators.mediatorObj.MediatorSprite;
import suites.mediators.mediatorObj.MediatorSpriteMediator;

/**
 * COMMENT
 * @author
 */
public class MediatorTests {
	
	private var messenger:Messenger;
	private var proxyMap:ProxyMap;
	private var mediatorMap:MediatorMap;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		messenger = MessengerManager.createMessenger("test");
		proxyMap = new ProxyMap(messenger);
		mediatorMap = new MediatorMap(messenger, proxyMap);
		
		mediatorMap.map(MediatorSprite, MediatorSpriteMediator);
		
		mediatorMap.mediate(new MediatorSprite());
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		MessengerManager.disposeMessenger("test");
		proxyMap = null;
		mediatorMap = null;
	}
	
	[Test(expects="Error")]
	
	public function test_empty_handler():void {
		if (CONFIG::debug == true) {
			messenger.send("test_add_empty_handler");
		} else {
			throw Error("Debug mode is needed for this test.");
		}
	}
	
	[Test]
	
	public function test_handler_object_params():void {
		messenger.send("test_handler_object_params");
	}
	
	[Test]
	
	public function test_handler_bad_params():void {
		messenger.send("test_handler_bad_params");
	}
	
	[Test(expects="Error")]
	
	public function test_handler_two_params():void {
		messenger.send("test_handler_two_params");
	}
	
	[Test]
	
	public function test_handler_two_params_one_optional():void {
		messenger.send("test_handler_two_params_one_optional");
	}

}
}