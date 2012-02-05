package suites.mediatorMap {
import org.flexunit.Assert;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;
import suites.mediatorMap.medatorMaptestObj.MediatorMapTestSprite;
import suites.mediatorMap.medatorMaptestObj.MediatorMapTestSpriteMediator;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author rbanevicius
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
		messenger = Messenger.getInstance();
		proxyMap = new ProxyMap(messenger);
		mediatorMap = new MediatorMap(messenger, proxyMap);
		callCaunter = 0;
		callsExpected = 0;
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		messenger.clear();
		proxyMap = null;
		mediatorMap = null;
		callCaunter = 0;
		callsExpected = 0;
	}
	
	[Test(async,description="Mediator onRegister test")]
	
	public function mediatorMap_onRegister_and_no_onRemove():void {
		MediatorMapTestSpriteMediator.REGISTER_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		MediatorMapTestSpriteMediator.REMOVE_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackFail, null, 300, callBackSuccess);
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);
	}
	
	[Test(async,description="Mediator onRemove test")]
	
	public function mediatorMap_onRegister_and_onRemove():void {
		MediatorMapTestSpriteMediator.REGISTER_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		MediatorMapTestSpriteMediator.REMOVE_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);
		mediatorMap.unmediate(view);
	}
	
	[Test(async,description="Mediator onRemove test")]
	
	public function mediatorMap_messag_callBack_test():void {
		MediatorMapTestSpriteMediator.CALLBACK_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);
		
		messenger.send(MediatorMapTestSpriteMediator.TEST_MESSAGE_TYPE);
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
		if (callCaunter != callsExpected){
			Assert.fail("Expected " + callsExpected + " calls, but " + callCaunter + " was received...");
		}
	}
	
	public function callBackIncrease(obj:* = null):void {
		//trace( "ControllerTests.callBackIncrease > obj : " + obj );
		callCaunter++;
	}

}
}