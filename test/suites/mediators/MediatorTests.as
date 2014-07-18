package suites.mediators {
import constants.TestExtensionDict;

import flash.events.Event;

import flexunit.framework.Assert;

import integration.aGenericTestObjects.constants.GenericTestMessage;
import integration.aframworkHelpers.ProxyMapCleaner;

import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

import suites.testObjects.view.MediatorSprite;
import suites.testObjects.view.MediatorSpriteDispacherChild;
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
	private var mediatorObject:MediatorSpriteMediator;
	private var eventHandledCount:int;

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

		mediatorObject = testView.mediator;

	}

	[After]

	public function runAfterEveryTest():void {
		use namespace pureLegsCore;

		ProxyMapCleaner.clear();

		mediatorMap.unmediate(testView);
		messenger = null;
		proxyMap = null;
		mediatorMap = null;
		testView = null;

		eventHandledCount = 0;
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


	//---------------
	// 	handler check
	//---------------

	[Test]
	public function mediator_addHandler_isHandledCheck_afterAdd_true():void {
		mediatorObject.test_addHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		Assert.assertTrue("Should be true...", mediatorObject.test_hasHandler(GenericTestMessage.TEST_MESSAGE, blankFunction));
	}

	[Test]
	public function mediator_addHandler_isHandledCheck_noAdd_false():void {
		Assert.assertFalse("Should be false...", mediatorObject.test_hasHandler(GenericTestMessage.TEST_MESSAGE, blankFunction));
	}

	[Test]
	public function mediator_addHandler_isHandledCheck_afterAddAndRemove_false():void {
		mediatorObject.test_addHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		mediatorObject.test_removeHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		Assert.assertFalse("Should be false...", mediatorObject.test_hasHandler(GenericTestMessage.TEST_MESSAGE, blankFunction));
	}

	//---------------
	// 	listener handling.
	//---------------

	[Test]
	public function mediator_addListenerHandled_afterAdd_handledOnce():void {
		//mediatorObject.test_addHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		//mediatorObject.test_removeHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		//Assert.assertFalse("Should be false...", mediatorObject.test_hasHandler(GenericTestMessage.TEST_MESSAGE, blankFunction));

		mediatorObject.test_addListener(testView.child1, "test", handleViewEvent);

		testView.child1.sendTestEvent();

		Assert.assertEquals("should be 1", 1, eventHandledCount);
	}

	[Test]
	public function mediator_addListenerHandled_afterAddAndRemove_nothandled():void {
		//mediatorObject.test_addHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		//mediatorObject.test_removeHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		//Assert.assertFalse("Should be false...", mediatorObject.test_hasHandler(GenericTestMessage.TEST_MESSAGE, blankFunction));

		mediatorObject.test_addListener(testView.child1, "test", handleViewEvent);
		mediatorObject.test_removeListener(testView.child1, "test", handleViewEvent);

		testView.child1.sendTestEvent();

		Assert.assertEquals("should be 0", 0, eventHandledCount);
	}

	[Test]
	public function mediator_addListenerHandled_afterAddAndRemoveAll_nothandled():void {
		//mediatorObject.test_addHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		//mediatorObject.test_removeHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		//Assert.assertFalse("Should be false...", mediatorObject.test_hasHandler(GenericTestMessage.TEST_MESSAGE, blankFunction));

		mediatorObject.test_addListener(testView.child1, "test", handleViewEvent);
		mediatorObject.test_removeAllListener();

		testView.child1.sendTestEvent();

		Assert.assertEquals("should be 0", 0, eventHandledCount);
	}

	[Test]
	public function mediator_addListenerHandled_afterAddTwice_handledTwice():void {
		//mediatorObject.test_addHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		//mediatorObject.test_removeHandler(GenericTestMessage.TEST_MESSAGE, blankFunction);
		//Assert.assertFalse("Should be false...", mediatorObject.test_hasHandler(GenericTestMessage.TEST_MESSAGE, blankFunction));

		mediatorObject.test_addListener(testView.child1, "test", handleViewEvent);
		mediatorObject.test_addListener(testView.child2, "test", handleViewEvent);

		testView.child1.sendTestEvent();
		testView.child2.sendTestEvent();

		Assert.assertEquals("should be 2", 2, eventHandledCount);
	}

	//---------------
	// 	helper
	//---------------

	private function handleViewEvent(event:Event):void {
		eventHandledCount++;
	}

	private function blankFunction(blank:Object):void {
	}


}
}