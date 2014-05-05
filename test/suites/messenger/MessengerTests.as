package suites.messenger {
import mvcexpress.core.messenger.HandlerVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

import org.flexunit.Assert;

import utils.AsyncUtil;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class MessengerTests {
	private var messenger:Messenger;

	[Before]

	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;

		Messenger.allowInstantiation = true;
		messenger = new Messenger("test");
		Messenger.allowInstantiation = false;
	}

	[After]

	public function runAfterEveryTest():void {
		use namespace pureLegsCore;

		messenger = null;
	}

	//----------------------------------
	//
	//----------------------------------

	[Test(async, description="Async Callback ")]

	public function add_and_handle_callback():void {
		messenger.addHandler("test", AsyncUtil.asyncHandler(this));
		messenger.send("test");
	}

	//----------------------------------
	//
	//----------------------------------

	[Test(async, description="Async fail Callback")]

	public function add_callback_and_sendNot_then_message_fails_silently():void {
		messenger.addHandler("test", AsyncUtil.asyncHandler(this, callBackFail, null, 300, callBackSuccess));
		messenger.send("test_notListened");
	}

	//----------------------------------
	//
	//----------------------------------

	[Test(async, description="Async Callback remove")]

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