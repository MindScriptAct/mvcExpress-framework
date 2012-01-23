package suites.commandMap {
import org.flexunit.Assert;
import org.pureLegs.core.CommandMap;
import org.pureLegs.core.MediatorMap;
import org.pureLegs.core.ModelMap;
import org.pureLegs.messenger.Messenger;
import suites.commandMap.commands.TestCommand1;
import suites.commandMap.commands.TestCommand2;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author rbanevicius
 */
public class CommandMapTests {
	private var messenger:Messenger;
	private var modelMap:ModelMap;
	private var mediatorMap:MediatorMap;
	private var cammandMap:CommandMap;
	private var callCaunter:int;
	private var callsExpected:int;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		messenger = new Messenger();
		modelMap = new ModelMap(messenger);
		mediatorMap = new MediatorMap(messenger, modelMap);
		cammandMap = new CommandMap(messenger, modelMap, mediatorMap);
		callCaunter = 0;
		callsExpected = 0;
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		messenger = null;
		modelMap = null;
		cammandMap = null;
		callCaunter = 0;
		callsExpected = 0;
	}
	
	[Test(async,description="Test command execution")]
	
	public function test_command_execute():void {
		
		TestCommand1.TEST_FUNCTION = AsyncUtil.asyncHandler(this)
		cammandMap.map("test", TestCommand1);
		messenger.send("test");
	}
	
	[Test(async,description="Test two command execution")]
	
	public function test_two_command_execute():void {
		callsExpected = 2;
		TestCommand1.TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackIncrease, null, 300, callBackCheck)
		TestCommand2.TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackIncrease, null, 300, callBackCheck)
		cammandMap.map("test", TestCommand1);
		cammandMap.map("test", TestCommand2);
		messenger.send("test");
	}
	
	[Test(async,description="Test two command add + 1 remove")]
	
	public function test_two_add_one_remove_command_execute():void {
		callsExpected = 1;
		TestCommand1.TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackIncrease, null, 300, callBackCheck)
		TestCommand2.TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackIncrease, null, 300, callBackCheck)
		cammandMap.map("test", TestCommand1);
		cammandMap.map("test", TestCommand2);
		cammandMap.unmap("test", TestCommand2);
		messenger.send("test");
	}
	
	[Test(async,description="commandMap.execute() test")]
	
	public function test_cammandMap_command_execute():void {
		callsExpected = 1;
		TestCommand1.TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackIncrease, null, 300, callBackCheck)
		cammandMap.execute(TestCommand1);
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