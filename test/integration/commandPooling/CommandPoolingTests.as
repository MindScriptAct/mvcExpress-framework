package integration.commandPooling {
import flexunit.framework.Assert;
import integration.commandPooling.testObj.CommandPoolingModule;
import integration.commandPooling.testObj.CommPoolingDependencyProxy;
import integration.commandPooling.testObj.controller.CommPoolingDependantCommand;
import integration.commandPooling.testObj.controller.CommPoolingDependencyRemove;
import integration.commandPooling.testObj.controller.CommPoolingLockedCommand;
import integration.commandPooling.testObj.controller.CommPoolingLockedFailCommand;
import integration.commandPooling.testObj.controller.CommPoolingSimpleCommand;
import integration.commandPooling.testObj.controller.CommPoolingUnlockedCommand;
import integration.mediating.testObj.*;
import integration.mediating.testObj.view.*;
import integration.mediating.testObj.view.viewObj.*;
import org.mvcexpress.core.*;

public class CommandPoolingTests {
	
	static private const EXECUTE_SIMPLE_POOLED_COMMAND:String = "executeSimplePooledCommand";
	static private const EXECUTE_POOLED_COMMAND_WITH_DEPENDENCY:String = "executePooledCommandWithDependency"
	static private const EXECUTE_POOLED_COMMAND_WITH_LOCK:String = "executePooledCommandWithLock";
	static private const EXECUTE_POOLED_COMMAND_WITH_UNLOCK_ONLY:String = "executePooledCommandWithUnlockOnly";
	static private const EXECUTE_POOLED_COMMAND_WITH_FAILING_LOCK:String = "executePooledCommandWithFailingLock";
	static public const EXECUTE_REMOVED_DEPENDENCY_COMMAND:String = "executeRemovedDependencyCommand";
	
	private var commandPoolingModule:CommandPoolingModule;
	private var commandPoolModuleCommandMap:CommandMap;
	private var commandPoolModuleProxyMap:ProxyMap;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		commandPoolingModule = new CommandPoolingModule();
		commandPoolModuleCommandMap = commandPoolingModule.getCommandMap();
		commandPoolModuleProxyMap = commandPoolingModule.getProxyMap();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		commandPoolModuleCommandMap = null;
		commandPoolingModule.disposeModule();
		commandPoolingModule = null;
		CommPoolingSimpleCommand.constructCount = 0;
		CommPoolingSimpleCommand.executeCount = 0;
		CommPoolingDependantCommand.constructCount = 0;
		CommPoolingDependantCommand.executeCount = 0;
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
	
	// map command
	// use cammand
	// clear pool.
	// use command
	// - must be 2 creations.
	
	[Test]
	
	public function commandPooling_clearCommandPoolUseTwice_commandCreatedTwice():void {
		commandPoolModuleCommandMap.map(EXECUTE_SIMPLE_POOLED_COMMAND, CommPoolingSimpleCommand);
		commandPoolingModule.sendLocalMessage(EXECUTE_SIMPLE_POOLED_COMMAND);
		commandPoolModuleCommandMap.clearCommandPool(CommPoolingSimpleCommand);
		commandPoolModuleCommandMap.map(EXECUTE_SIMPLE_POOLED_COMMAND, CommPoolingSimpleCommand);
		commandPoolingModule.sendLocalMessage(EXECUTE_SIMPLE_POOLED_COMMAND);
		
		Assert.assertEquals("Pooled command should be created twice after it is cleared.", 2, CommPoolingSimpleCommand.constructCount);
	}
	
	// map command
	// use command - lock
	// use command - lock
	// - must be 2 creations.
	
	[Test]
	
	public function commandPooling_useCommandWithLock_commandCreatedTwice():void {
		commandPoolModuleCommandMap.map(EXECUTE_POOLED_COMMAND_WITH_LOCK, CommPoolingLockedCommand);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_LOCK);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_LOCK);
		Assert.assertEquals("Pooled command with lock should be created twice.", 2, CommPoolingLockedCommand.constructCount);
	}
	
	// map command
	// use command - unlock
	// - error - must be locked first
	
	[Test(expects="Error")]
	
	public function commandPooling_useCommandWithUnlockBeforeLock_fails():void {
		commandPoolModuleCommandMap.map(EXECUTE_POOLED_COMMAND_WITH_UNLOCK_ONLY, CommPoolingUnlockedCommand);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_UNLOCK_ONLY);
	}
	
	//----------------------------------
	//     dependencies
	//----------------------------------
	
	// map dependency
	// map command
	// use command
	// remove dependency
	// use command 
	// - must be error - missing dependency.
	
	[Test(expects="Error")]
	
	public function commandPooling_useCommandWithUnmapedDependency_fails():void {
		commandPoolModuleProxyMap.map(new CommPoolingDependencyProxy());
		commandPoolModuleCommandMap.map(EXECUTE_POOLED_COMMAND_WITH_DEPENDENCY, CommPoolingDependantCommand);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_DEPENDENCY);
		commandPoolModuleProxyMap.unmap(CommPoolingDependencyProxy);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_DEPENDENCY);
	}
	
	// map dependency
	// map command
	// use command
	// remove dependency
	// map dependency
	// use command 
	// - must be 2 creations.
	
	[Test]
	
	public function commandPooling_useCommandWithRemapedDependency_commandCreatedTwice():void {
		commandPoolModuleProxyMap.map(new CommPoolingDependencyProxy());
		commandPoolModuleCommandMap.map(EXECUTE_POOLED_COMMAND_WITH_DEPENDENCY, CommPoolingDependantCommand);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_DEPENDENCY);
		commandPoolModuleProxyMap.unmap(CommPoolingDependencyProxy);
		commandPoolModuleProxyMap.map(new CommPoolingDependencyProxy());
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_DEPENDENCY);
		
		Assert.assertEquals("Pooled command should be created twice.", 2, CommPoolingDependantCommand.constructCount);
	}
	
	// map dependency
	// map command
	// use command
	// lock command
	// remove dependency
	// unlock command
	// use command
	// - must be error for missing dependency.
	
	[Test(expects="Error")]
	
	public function commandPooling_useCommandLockingWithRemovedDependery_secorndCommandUseFails():void {
		CommPoolingLockedFailCommand.executedProxyNames = "";
		commandPoolModuleProxyMap.map(new CommPoolingDependencyProxy("proxy1"));
		commandPoolModuleCommandMap.map(EXECUTE_POOLED_COMMAND_WITH_FAILING_LOCK, CommPoolingLockedFailCommand);
		commandPoolModuleCommandMap.map(CommandPoolingTests.EXECUTE_REMOVED_DEPENDENCY_COMMAND, CommPoolingDependencyRemove);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_FAILING_LOCK);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_FAILING_LOCK);
	}
	
	// map dependency 1
	// map command
	// use command
	// lock command
	// remove dependency
	// unlock command
	// map dependency 2
	// use command
	// - must use dependercy 2.
	
	[Test]
	
	public function commandPooling_useCommandLockingWithChangedDependery_secorndCommandUseSecondDependercy():void {
		CommPoolingLockedFailCommand.executedProxyNames = "";
		commandPoolModuleProxyMap.map(new CommPoolingDependencyProxy("proxy1"));
		commandPoolModuleCommandMap.map(EXECUTE_POOLED_COMMAND_WITH_FAILING_LOCK, CommPoolingLockedFailCommand);
		commandPoolModuleCommandMap.map(CommandPoolingTests.EXECUTE_REMOVED_DEPENDENCY_COMMAND, CommPoolingDependencyRemove);
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_FAILING_LOCK);
		commandPoolModuleProxyMap.map(new CommPoolingDependencyProxy("-proxy2"));
		commandPoolingModule.sendLocalMessage(EXECUTE_POOLED_COMMAND_WITH_FAILING_LOCK);
		Assert.assertEquals("Pooled comamnd dependency swap while command is locked should end in pooled command reinstantiation.", "proxy1-proxy2", CommPoolingLockedFailCommand.executedProxyNames);
	}
}
}