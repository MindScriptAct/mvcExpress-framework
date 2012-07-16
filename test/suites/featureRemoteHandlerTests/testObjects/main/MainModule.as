package suites.featureRemoteHandlerTests.testObjects.main {
import org.mvcexpress.modules.ModuleSprite;
import suites.SuiteModuleNames;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MainModule extends ModuleSprite {
	
	private var dataProxy:MainDataProxy;
	private var testView:MainView;
	
	static public const NAME:String = SuiteModuleNames.MAIN_MODULE;
	
	public function MainModule() {
		super(MainModule.NAME, true, false);
	}
	
	override protected function onInit():void {
		dataProxy = new MainDataProxy();
		proxyMap.map(dataProxy);
		mediatorMap.map(MainView, MainViewMediator);
	}
	
	override protected function onDispose():void {
		proxyMap.unmap(MainDataProxy);
		dataProxy = null;
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	public function createLocalCommand(message:String):void {
		commandMap.map(message, MainLocalCommand)
	}
	
	public function createLocalHandler(message:String):void {
		if (!testView) {
			testView = new MainView();
			mediatorMap.mediate(testView);
		}
		testView.addLocalhandler();
	}
	
	public function createRemoteCommand(message:String):void {
		commandMap.mapRemote(message, MainRemoteCommand, SuiteModuleNames.EXTERNAL_MODULE);
	}
	
	public function createRemoteHandler(message:String):void {
		if (!testView) {
			testView = new MainView();
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