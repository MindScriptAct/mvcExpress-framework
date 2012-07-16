package suites.mediators {
import flexunit.framework.Assert;
import org.mvcexpress.core.MediatorMap;
import org.mvcexpress.core.ModuleManager;
import org.mvcexpress.core.ProxyMap;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
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
	private var testView:MediatorSprite;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		Messenger.allowInstantiation = true;
		messenger = new Messenger("test");
		Messenger.allowInstantiation = false;
		proxyMap = new ProxyMap("test", messenger);
		mediatorMap = new MediatorMap("test", messenger, proxyMap);
		
		mediatorMap.map(MediatorSprite, MediatorSpriteMediator);
		
		testView = new MediatorSprite()
		
		mediatorMap.mediate(testView);
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		messenger = null;
		proxyMap = null;
		mediatorMap = null;
		testView = null;
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
	
	[Test]
	
	public function test_same_handler_added_twice_fails():void {
		if (CONFIG::debug == true) {
			try {
				testView.tryAddingHandlerTwice();
				Assert.fail("Adding handlen twice should fail.");
			} catch (err:Error) {
			}
		}
	}
	

}
}