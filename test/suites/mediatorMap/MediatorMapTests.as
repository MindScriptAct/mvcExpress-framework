package suites.mediatorMap {
import flash.display.Bitmap;
import flash.display.Sprite;

import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

import org.flexunit.Assert;

import suites.mediatorMap.medatorMaptestObj.MediatorMapTestSprite;
import suites.mediatorMap.medatorMaptestObj.MediatorMapTestSpriteMediator;
import suites.testObjects.view.MediatorSprite;
import suites.testObjects.view.MediatorSpriteMediator;

import utils.AsyncUtil;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MediatorMapTests {

	private var messenger:Messenger;
	private var proxyMap:ProxyMap;
	private var mediatorMap:MediatorMap;
	private var callCaunter:int;
	private var callsExpected:int;

	[Before]

	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;

		Messenger.allowInstantiation = true;
		messenger = new Messenger("test");
		Messenger.allowInstantiation = false;
		proxyMap = new ProxyMap("test", messenger);
		mediatorMap = new MediatorMap("test", messenger, proxyMap);
		callCaunter = 0;
		callsExpected = 0;
	}

	[After]

	public function runAfterEveryTest():void {
		use namespace pureLegsCore;

		messenger = null;
		proxyMap = null;
		mediatorMap = null;
		callCaunter = 0;
		callsExpected = 0;

	}

	[Test(async, description="Mediator onRegister test")]

	public function mediatorMap_onRegister_and_no_onRemove():void {
		MediatorMapTestSpriteMediator.REGISTER_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		MediatorMapTestSpriteMediator.REMOVE_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackFail, null, 300, callBackSuccess);
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);
	}

	[Test(async, description="Mediator onRemove test")]

	public function mediatorMap_onRegister_and_onRemove():void {
		MediatorMapTestSpriteMediator.REGISTER_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		MediatorMapTestSpriteMediator.REMOVE_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);
		mediatorMap.unmediate(view);
	}

	[Test(async, description="Mediator onRemove test")]

	public function mediatorMap_messag_callBack_test():void {
		MediatorMapTestSpriteMediator.CALLBACK_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);

		messenger.send(MediatorMapTestSpriteMediator.TEST_MESSAGE_TYPE);
	}

	[Test(expects="Error")]

	public function mediatorMap_doubleMediate_fails():void {
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);
		mediatorMap.mediate(view);
	}

	[Test]

	public function mediatorMap_mediateWith_notFails():void {
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediateWith(view, MediatorMapTestSpriteMediator);
	}

	[Test(expects="Error")]

	public function mediatorMap_doubleMediateWith_fails():void {
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediateWith(view, MediatorMapTestSpriteMediator);
		mediatorMap.mediateWith(view, MediatorMapTestSpriteMediator);

	}

	//----------------------------------
	//     isMapped()
	//----------------------------------

	[Test]

	public function debug_test_isMapped_false_wrong_view():void {
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		Assert.assertFalse("isMapped() should retturn false with NOT mapped view class.", mediatorMap.isMapped(MediatorSprite, MediatorMapTestSpriteMediator));
	}

	[Test]

	public function debug_test_isMapped_false_wrong_mediator():void {
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		Assert.assertFalse("isMapped() should retturn false with NOT mapped mediator class to view.", mediatorMap.isMapped(MediatorMapTestSprite, MediatorSpriteMediator));
	}

	[Test]

	public function debug_test_isMapped_true():void {
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		Assert.assertTrue("isMapped() should retturn true with mapped view class to mediator class.", mediatorMap.isMapped(MediatorMapTestSprite, MediatorMapTestSpriteMediator));
	}

	[Test(expects="Error")]

	public function debug_map_not_mediator_fails():void {
		var errorChecked:Boolean = false;
		CONFIG::debug {
			errorChecked = true;
			mediatorMap.map(Sprite, Bitmap);
		}
		if (!errorChecked) {
			Assert.fail("fake error")
		}
	}

	//----------------------------------
	//
	//----------------------------------
	private function callBackFail(obj:* = null):void {
		Assert.fail("CallBack should not be called...");
	}

	public function callBackSuccess(obj:* = null):void {
	}

	//----------------------------------
	//
	//----------------------------------
	private function callBackCheck(obj:* = null):void {
		//trace( "ControllerTests.callBackCheck > obj : " + obj );
		if (callCaunter != callsExpected) {
			Assert.fail("Expected " + callsExpected + " calls, but " + callCaunter + " was received...");
		}
	}

	public function callBackIncrease(obj:* = null):void {
		//trace( "ControllerTests.callBackIncrease > obj : " + obj );
		callCaunter++;
	}

}
}