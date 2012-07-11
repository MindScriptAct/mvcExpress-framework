package suites.messenger {
import org.flexunit.Assert;
import org.flexunit.internals.builders.NullBuilder;
import org.mvcexpress.core.ModuleManager;
import org.mvcexpress.messenger.HandlerVO;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MessengerTests {
	private var messenger:Messenger;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		messenger = ModuleManager.createMessenger("test");
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		ModuleManager.disposeMessenger("test");
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	[Test(async,description="Async Callback ")]
	
	public function add_and_handle_callback():void {
		messenger.addHandler("test", AsyncUtil.asyncHandler(this));
		messenger.send("test");
	}
	
	//----------------------------------
	//     
	//----------------------------------	
	
	[Test(async,description="Async fail Callback")]
	
	public function add_callback_and_sendNot_then_message_fails_silently():void {
		messenger.addHandler("test", AsyncUtil.asyncHandler(this, callBackFail, null, 300, callBackSuccess));
		messenger.send("test_notListened");
	}
	
	//----------------------------------
	//     
	//----------------------------------		
	
	[Test(async,description="Async Callback disable")]
	
	public function add_callback_and_disable_then_message_fails_silently():void {
		var callBack:Function = AsyncUtil.asyncHandler(this, callBackFail, null, 300, callBackSuccess);
		var handlerVo:HandlerVO = messenger.addHandler("test", callBack);
		handlerVo.handler = null;
		messenger.send("test");
	}
	
	//----------------------------------
	//     
	//----------------------------------		
	
	[Test(async,description="Async Callback remove")]
	
	public function add_and_remove_callback_then_message_fails_silently():void {
		var callBack:Function = AsyncUtil.asyncHandler(this, callBackFail, null, 300, callBackSuccess);
		messenger.addHandler("test", callBack);
		messenger.removeHandler("test", callBack);
		messenger.send("test");
	}
	
	//----------------------------------
	//     
	//----------------------------------			
	private function callBackFail(obj:*):void {
		Assert.fail("CallBack should not be called...");
	}
	
	public function callBackSuccess(obj:*):void {
	}

}
}