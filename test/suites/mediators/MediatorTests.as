package suites.mediators {
import constants.TestExtensionDict;

import flexunit.framework.Assert;

import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

import suites.testObjects.view.MediatorSprite;
import suites.testObjects.view.MediatorSpriteMediator;

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

		CONFIG::debug {
			messenger.setSupportedExtensions(TestExtensionDict.getDefaultExtensionDict());
			proxyMap.setSupportedExtensions(TestExtensionDict.getDefaultExtensionDict());
			mediatorMap.setSupportedExtensions(TestExtensionDict.getDefaultExtensionDict());
		}


		mediatorMap.map(MediatorSprite, MediatorSpriteMediator);

		testView = new MediatorSprite()

		mediatorMap.mediate(testView);

	}

	[After]

	public function runAfterEveryTest():void {
		use namespace pureLegsCore;

		mediatorMap.unmediate(testView);
		messenger = null;
		proxyMap = null;
		mediatorMap = null;
		testView = null;
	}

	[Test(expects="Error")]

	public function mediator_constructor_fails():void {
		CONFIG::debug {
			new MediatorSpriteMediator();
			return;
		}
		throw Error("Fake error.");
	}

	[Test(expects="Error")]

	public function mediator_empty_handler():void {
		if (CONFIG::debug == true) {
			messenger.send("test_add_empty_handler");
		} else {
			throw Error("Debug mode is needed for this test.");
		}
	}


	//[Test]
	//[Ignore]
	//public function mediator_add_listener():void {
	//
	//}
	//
	//[Test]
	//[Ignore]
	//public function mediator_remove_listener():void {
	//
	//}
	//
	//[Test]
	//[Ignore]
	//public function mediator_remove_all_listeners():void {
	//
	//}


	[Test]

	public function mediator_handler_object_params():void {
		messenger.send("test_handler_object_params");
	}

	[Test]

	public function mediator_handler_bad_params():void {
		messenger.send("test_handler_bad_params");
	}

	[Test(expects="Error")]

	public function mediator_handler_two_params():void {
		messenger.send("test_handler_two_params");
	}

	[Test]

	public function mediator_handler_two_params_one_optional():void {
		messenger.send("test_handler_two_params_one_optional");
	}

	[Test]

	public function mediator_same_handler_added_twice_fails():void {
		if (CONFIG::debug == true) {
			try {
				testView.tryAddingHandlerTwice();
				Assert.fail("Adding handlen twice should fail.");
			} catch (err:Error) {
			}
		}
	}

	//[Test]
	//[Ignore]
	//public function mediator_remove_handler():void {
	//
	//}
	//
	//
	//[Test]
	//[Ignore]
	//public function mediator_remove_all_handler():void {
	//
	//}


}
}