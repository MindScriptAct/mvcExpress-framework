package integration.commandPooling {
import flexunit.framework.Assert;
import integration.commandPooling.testObj.CommandPoolingModule;
import integration.commandPooling.testObj.controller.CommPoolingSimpleCommand;
import integration.mediating.testObj.*;
import integration.mediating.testObj.view.*;
import integration.mediating.testObj.view.viewObj.*;
import org.mvcexpress.core.*;


public class CommandPoolingTests {
	
	static private const EXECUTE_SIMPLE_POOLED_COMMAND:String = "executeSimplePooledCommand";
	
	
	private var commandPoolingModule:CommandPoolingModule;
	private var commandPoolModuleCommandMap:CommandMap;;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		commandPoolingModule = new CommandPoolingModule();
		commandPoolModuleCommandMap = commandPoolingModule.getCommandMap();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		commandPoolModuleCommandMap = null;
		commandPoolingModule.disposeModule();
		commandPoolingModule = null;
		CommPoolingSimpleCommand.constructCount = 0;
		CommPoolingSimpleCommand.executeCount = 0;
	}
	
	[Test]
	
	public function commandPooling_cashingCammandUsedTwice_constructedOnce():void {
		commandPoolModuleCommandMap.map(EXECUTE_SIMPLE_POOLED_COMMAND, CommPoolingSimpleCommand);
		//
		commandPoolingModule.sendLocalMessage(EXECUTE_SIMPLE_POOLED_COMMAND);
		commandPoolingModule.sendLocalMessage(EXECUTE_SIMPLE_POOLED_COMMAND);
		
		Assert.assertEquals("Pooled command should be instantiated only once.", 1, CommPoolingSimpleCommand.constructCount);
	}
	
	[Test]
	
	public function commandPooling_cashingCammandUsedTwice_executedTwice():void {
		commandPoolModuleCommandMap.map(EXECUTE_SIMPLE_POOLED_COMMAND, CommPoolingSimpleCommand);
		//
		commandPoolingModule.sendLocalMessage(EXECUTE_SIMPLE_POOLED_COMMAND);
		commandPoolingModule.sendLocalMessage(EXECUTE_SIMPLE_POOLED_COMMAND);
		
		Assert.assertEquals("Pooled command should be executed twice.", 2, CommPoolingSimpleCommand.executeCount);
	}	
	

}
}