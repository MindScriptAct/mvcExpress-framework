package suites.featureRemoteHandlerTests {
import flexunit.framework.Assert;
import suites.testObjects.external.ExternalModule;
import suites.testObjects.main.MainModule;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class FeatureRemoteHandlerScenarioTests {
	
	private var mainModule:MainModule;
	private var externalModule:ExternalModule;
	
	[Before]
	public function runBeforeEveryTest():void {
	}
	
	[After]
	public function runAfterEveryTest():void {
		if (mainModule) {
			mainModule.disposeModule();
			mainModule = null;
		}
		if (externalModule) {
			externalModule.disposeModule();
			externalModule = null;
		}
	}
	
	//----------------------------------
	//     single local message
	//----------------------------------
	
	[Test(description="just starting module with remote command")]
	
	public function featureRemoteMessangingScenario_starting_module_with_remote_command():void {
		externalModule = new ExternalModule();
		externalModule.createRemoteCommand("test");
	}
	
	[Test(description="just starting module with remote handler")]
	
	public function featureRemoteMessangingScenario_starting_module_with_remote_handler():void {
		externalModule = new ExternalModule();
		externalModule.createRemoteHandler("test");
	}
	
	[Test(description="starting module with remote command, then creating main module, and trigering command.")]
	
	public function featureRemoteMessangingScenario_starting_module_with_remote_command_then_adding_main_and_trigering_command():void {
		externalModule = new ExternalModule();
		externalModule.createRemoteCommand("test");
		//
		var mainModule:MainModule = new MainModule();
		mainModule.sendTestMessage("test");
		Assert.assertEquals("External module command must be called once.", externalModule.remoteCommandCount, 1);
	}
	
	[Test(description="starting module with remote handler, then creating main module, and trigering handler.")]
	
	public function featureRemoteMessangingScenario_starting_module_with_remote_handler_then_adding_main_and_trigering_handler():void {
		externalModule = new ExternalModule();
		externalModule.createRemoteHandler("test");
		//
		var mainModule:MainModule = new MainModule();
		mainModule.sendTestMessage("test");
		Assert.assertEquals("External module command must be called once.", externalModule.remoteCommandCount, 1);
	}
	
	
	//----------------------------------
	//     
	//----------------------------------
	
	
	// create remote
	// add remote handler/command
	// dispose remote
	// create main
	// call handler
	// remote handler should not be trigered.
	
	
	// create remote
	// add remote handler/command
	// remove remote handler/command
	// create main
	// call handler
	// remote handler should be not colled
	
	
	// create remote
	// add remote handler/command
	// dispose remote
	// create remote
	// add remote handler/command	
	// create main
	// call handler
	// remote handler should be trigered only once	
	
	
	
	// create main
	// create remote
	// add remote handler/command
	// dispose main
	// create main
	// call handler
	// remote handler should be trigered once		
	
	
	
	
	
	
	
}
}