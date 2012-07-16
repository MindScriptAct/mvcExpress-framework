package suites.featureRemoteHandlerTests {
import flexunit.framework.Assert;
import suites.featureRemoteHandlerTests.testObjects.external.ExternalModule;
import suites.featureRemoteHandlerTests.testObjects.main.MainModule;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class FeatureRemoteHandlerTests {
	
	private var mainModule:MainModule;
	private var externalModule:ExternalModule;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		mainModule = new MainModule();
		externalModule = new ExternalModule();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		mainModule.disposeModule();
		externalModule.disposeModule();
	}
	
	//----------------------------------
	//     single local message
	//----------------------------------
	
	[Test(description="just trigering local command in main")]
	
	public function featureRemoteMessanging_main_local_command():void {
		mainModule.createLocalCommand("test");
		mainModule.sendTestMessage("test");
		Assert.assertEquals("Main module command must be called once.", mainModule.localCommandCount, 1);
	}
	
	[Test(description="just trigering local command in external")]
	
	public function featureRemoteMessanging_external_local_command():void {
		externalModule.createLocalCommand("test");
		externalModule.sendTestMessage("test");
		Assert.assertEquals("External module command must be called once.", externalModule.localCommandCount, 1);
	}
	
	[Test(description="just trigering local handler in main")]
	
	public function featureRemoteMessanging_main_local_handler():void {
		mainModule.createLocalHandler("test");
		mainModule.sendTestMessage("test");
		Assert.assertEquals("Main module handler must be called once.", mainModule.localHandlerCount, 1);
	}
	
	[Test(description="just trigering local handler in external")]
	
	public function featureRemoteMessanging_external_local_handler():void {
		externalModule.createLocalHandler("test");
		externalModule.sendTestMessage("test");
		Assert.assertEquals("External module handler must be called once.", externalModule.localHandlerCount, 1);
	}
	
	//----------------------------------
	//     single remote message
	//----------------------------------	
	
	[Test(description="trigering remote command in main")]
	
	public function featureRemoteMessanging_main_remote_command():void {
		mainModule.createRemoteCommand("test");
		externalModule.sendTestMessage("test");
		Assert.assertEquals("Main module command must be called once.", mainModule.remoteCommandCount, 1);
	}
	
	[Test(description="trigering remote command in external")]
	
	public function featureRemoteMessanging_external_remote_command():void {
		externalModule.createRemoteCommand("test");
		mainModule.sendTestMessage("test");
		Assert.assertEquals("External module command must be called once.", externalModule.remoteCommandCount, 1);
	}
	
	[Test(description="trigering remote handler in main")]
	
	public function featureRemoteMessanging_main_remote_handler():void {
		mainModule.createRemoteHandler("test");
		externalModule.sendTestMessage("test");
		Assert.assertEquals("Main module handler must be called once.", mainModule.remoteHandlerCount, 1);
	}
	
	[Test(description="trigering remote handler in external")]
	
	public function featureRemoteMessanging_external_remote_handler():void {
		externalModule.createRemoteHandler("test");
		mainModule.sendTestMessage("test");
		Assert.assertEquals("External module handler must be called once.", externalModule.remoteHandlerCount, 1);
	}
	
	//----------------------------------
	//     mixed mesages
	//----------------------------------	
	
	[Test(description="mixed messages to local and remote comands")]
	
	public function featureRemoteMessanging_mixed_messages_local_and_remote_command():void {
		mainModule.createLocalCommand("test_local");
		mainModule.sendTestMessage("test_local");
		
		mainModule.createRemoteCommand("test_remote");
		externalModule.sendTestMessage("test_remote");
		
		Assert.assertEquals("Main module local command must be called once.", mainModule.localCommandCount, 1);
		Assert.assertEquals("Main module remote command must be called once.", mainModule.remoteCommandCount, 1);
	}
	
	[Test(description="same messages to local and remote commands")]
	
	public function featureRemoteMessanging_same_messages_local_and_remote_command():void {
		mainModule.createLocalCommand("test");
		mainModule.sendTestMessage("test");
		
		mainModule.createRemoteCommand("test");
		externalModule.sendTestMessage("test");
		
		Assert.assertEquals("Main module local command must be called once.", mainModule.localCommandCount, 1);
		Assert.assertEquals("Main module remote command must be called once.", mainModule.remoteCommandCount, 1);
	}	
	
	[Test(description="mixed messages to local and remote handlers")]
	
	public function featureRemoteMessanging_mixed_messages_local_and_remote_handler():void {
		mainModule.createLocalHandler("test_local");
		mainModule.sendTestMessage("test_local");
		
		mainModule.createRemoteHandler("test_remote");
		externalModule.sendTestMessage("test_remote");
		
		Assert.assertEquals("Main module local command must be called once.", mainModule.localHandlerCount, 1);
		Assert.assertEquals("Main module remote command must be called once.", mainModule.remoteHandlerCount, 1);
	}
	
	[Test(description="same messages to local and remote handlers")]
	
	public function featureRemoteMessanging_same_messages_local_and_remote_handler():void {
		mainModule.createLocalHandler("test");
		mainModule.sendTestMessage("test");
		
		mainModule.createRemoteHandler("test");
		externalModule.sendTestMessage("test");
		
		Assert.assertEquals("Main module local command must be called once.", mainModule.localHandlerCount, 1);
		Assert.assertEquals("Main module remote command must be called once.", mainModule.remoteHandlerCount, 1);
	}
}
}