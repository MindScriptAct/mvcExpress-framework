package suites.commandMap {
import flash.display.Sprite;
import org.flexunit.Assert;
import org.mvcexpress.base.CommandMap;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;
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
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class CommandMapTests {
	private var messenger:Messenger;
	private var proxyMap:ProxyMap;
	private var mediatorMap:MediatorMap;
	private var cammandMap:CommandMap;
	private var callCaunter:int;
	private var callsExpected:int;
	private var testParamObject:ExtendedSuperObject;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		proxyMap = new ProxyMap(messenger);
		mediatorMap = new MediatorMap(messenger, proxyMap);
		cammandMap = new CommandMap(messenger, proxyMap, mediatorMap);
		callCaunter = 0;
		callsExpected = 0;
		testParamObject = new ExtendedSuperObject();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		messenger.clear();
		messenger = null;
		proxyMap = null;
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
		if (CONFIG::debug == true) {
			cammandMap.map("test", NoExecuteCommand);
		} else {
			throw Error("Debug mode is needed for this test.");
		}
	}
	
	[Test(expects="Error")]
	
	public function test_no_params_command_map():void {
		if (CONFIG::debug == true) {
			cammandMap.map("test", NoParamsCommand);
		} else {
			throw Error("Debug mode is needed for this test.");
		}		
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
	//     isMapped()
	//----------------------------------
	
	[Test]
	
	public function debug_test_isMapped_false_wrong_message():void {
		cammandMap.map("test", TestCommand1);
		Assert.assertFalse("isMapped() should retturn false with NOT mapped message.", cammandMap.isMapped("test1", TestCommand1));
	}
	
	[Test]
	
	public function debug_test_isMapped_false_wrong_class():void {
		cammandMap.map("test", TestCommand1);
		Assert.assertFalse("isMapped() should retturn false with NOT mapped command class to message.", cammandMap.isMapped("test", TestCommand2));
	}
	
	[Test]
	
	public function debug_test_isMapped_true():void {
		cammandMap.map("test", TestCommand1);
		Assert.assertTrue("isMapped() should retturn true with mapped proxy.", cammandMap.isMapped("test", TestCommand1));
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