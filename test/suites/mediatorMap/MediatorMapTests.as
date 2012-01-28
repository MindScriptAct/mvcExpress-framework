package suites.mediatorMap {
import com.mindScriptAct.pureLegsTest.view.testSprite.TestSprite;
import org.flexunit.Assert;
import org.pureLegs.core.MediatorMap;
import org.pureLegs.core.ModelMap;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.namespace.pureLegsCore;
import suites.mediatorMap.medatorMaptestObj.MediatorMapTestSprite;
import suites.mediatorMap.medatorMaptestObj.MediatorMapTestSpriteMediator;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author rbanevicius
 */
public class MediatorMapTests {
	
	private var messenger:Messenger;
	private var modelMap:ModelMap;
	private var mediatorMap:MediatorMap;
	private var callCaunter:int;
	private var callsExpected:int;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		modelMap = new ModelMap(messenger);
		mediatorMap = new MediatorMap(messenger, modelMap);
		callCaunter = 0;
		callsExpected = 0;
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		messenger.clear();
		modelMap = null;
		mediatorMap = null;
		callCaunter = 0;
		callsExpected = 0;
	}
	
	[Test(async,description="Mediator onRegister test")]
	
	public function mediatorMap_onRegister_and_no_onRemove():void {
		MediatorMapTestSpriteMediator.REGISTER_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		MediatorMapTestSpriteMediator.REMOVE_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackFail, null, 300, callBackSuccess);
		mediatorMap.mapMediator(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);
	}
	
	[Test(async,description="Mediator onRemove test")]
	
	public function mediatorMap_onRegister_and_onRemove():void {
		MediatorMapTestSpriteMediator.REGISTER_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		MediatorMapTestSpriteMediator.REMOVE_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		mediatorMap.mapMediator(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
		var view:MediatorMapTestSprite = new MediatorMapTestSprite();
		mediatorMap.mediate(view);
		mediatorMap.unmediate(view);
	}
	
	[Test(async,description="Mediator onRemove test")]
	
	public function mediatorMap_messag_callBack_test():void {
		MediatorMapTestSpriteMediator.CALLBACK_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
		mediatorMap.mapMediator(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
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