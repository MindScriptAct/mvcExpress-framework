package suites.commandMap {
import flash.display.Sprite;
import org.flexunit.Assert;
import org.pureLegs.core.CommandMap;
import org.pureLegs.core.MediatorMap;
import org.pureLegs.core.ModelMap;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.namespace.pureLegsCore;
import suites.commandMap.commands.ExtendedeSuperInterfaceParamsCommand;
import suites.commandMap.commands.ExtendedSuperParamCommand;
import suites.commandMap.commands.NoExecuteCommand;
import suites.commandMap.commands.NoParamsCommand;
import suites.commandMap.commands.SuperInterfaceParamCommand;
import suites.commandMap.commands.SuperParamCommand;
import suites.commandMap.commands.TestCommand1;
import suites.commandMap.commands.TestCommand2;
import suites.testObjects.ExtendedSuperObject;
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
	private var testParamObject:ExtendedSuperObject;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		modelMap = new ModelMap(messenger);
		mediatorMap = new MediatorMap(messenger, modelMap);
		cammandMap = new CommandMap(messenger, modelMap, mediatorMap);
		callCaunter = 0;
		callsExpected = 0;
		testParamObject = new ExtendedSuperObject();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		messenger.clear();
		messenger = null;
		modelMap = null;
		cammandMap = null;
		callCaunter = 0;
		callsExpected = 0;
		testParamObject = null;
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
	
	[Test(expects="Error")]
	
	public function test_no_execute_command_map():void {
		cammandMap.map("test", NoExecuteCommand);
	}
	
	[Test(expects="Error")]
	
	public function test_no_params_command_map():void {
		cammandMap.map("test", NoParamsCommand);
	}
	
	[Test]
	
	public function execute_command_with_no_param():void {
		cammandMap.execute(ExtendedSuperParamCommand);
	}
	
	[Test]
	
	public function execute_command_with_extended_object_param():void {
		cammandMap.execute(ExtendedSuperParamCommand, testParamObject);
	}
	
	[Test]
	
	public function execute_command_with_intefrace_of_extended_object_param():void {
		cammandMap.execute(ExtendedeSuperInterfaceParamsCommand, testParamObject);
	}
	
	[Test]
	
	public function execute_command_with_superclass_object_param():void {
		cammandMap.execute(SuperParamCommand, testParamObject);
	}
	
	[Test]
	
	public function execute_command_with_intefrace_of_superclass_object_param():void {
		cammandMap.execute(SuperInterfaceParamCommand, testParamObject);
	}
	
	[Test(expects="Error")]
	
	public function execute_command_with_bad_typed_object_param():void {
		cammandMap.execute(SuperInterfaceParamCommand, new Sprite());
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