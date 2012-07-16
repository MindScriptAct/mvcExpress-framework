package suites.featureRemoteHandlerTests.testObjects.external {
import org.mvcexpress.modules.ModuleSprite;
import suites.SuiteModuleNames;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ExternalModule extends ModuleSprite {
	
	private var dataProxy:ExternalDataProxy;
	private var testView:ExternalView;
	
	static public const NAME:String = SuiteModuleNames.EXTERNAL_MODULE;
	
	public function ExternalModule() {
		super(ExternalModule.NAME, true, false);
	}
	
	override protected function onInit():void {
		dataProxy = new ExternalDataProxy();
		proxyMap.map(dataProxy);
		mediatorMap.map(ExternalView, ExternalViewMediator);
	}
	
	override protected function onDispose():void {
		proxyMap.unmap(ExternalDataProxy);
		dataProxy = null;
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	public function createLocalCommand(message:String):void {
		commandMap.map(message, ExternalLocalCommand);
	}
	
	public function createLocalHandler(message:String):void {
		if (!testView) {
			testView = new ExternalView();
			mediatorMap.mediate(testView);
		}
		testView.addLocalhandler();
	}
	
	public function createRemoteCommand(message:String):void {
		commandMap.mapRemote(message, ExternalRemoteCommand, SuiteModuleNames.MAIN_MODULE);
	}
	
	public function createRemoteHandler(message:String):void {
		if (!testView) {
			testView = new ExternalView();
			mediatorMap.mediate(testView);
		}
		testView.addRemoteHandler();
	}
	
	public function sendTestMessage(message:String):void {
		sendMessage(message);
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	public function get localCommandCount():int {
		return dataProxy.localCommandCount;
	}
	
	public function get localHandlerCount():int {
		return dataProxy.localHandlerCount;
	}
	
	public function get remoteCommandCount():int {
		return dataProxy.remoteCommandCount;
	}
	
	public function get remoteHandlerCount():int {
		return dataProxy.remoteHandlerCount;
	}
}
}