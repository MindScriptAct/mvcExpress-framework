package suites.testObjects.external {
import org.mvcexpress.modules.ModuleSprite;
import suites.SuiteModuleNames;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
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
		testView.addLocalhandler(message);
	}
	
	public function createRemoteCommand(message:String):void {
		commandMap.mapRemote(message, ExternalRemoteCommand, SuiteModuleNames.MAIN_MODULE);
	}
	
	public function createRemoteHandler(message:String):void {
		if (!testView) {
			testView = new ExternalView();
			mediatorMap.mediate(testView);
		}
		testView.addRemoteHandler(message);
	}
	
	public function sendTestMessage(message:String):void {
		sendMessage(message);
	}
	
	public function removeLocalCommand(message:String):void {
		commandMap.unmap(message, ExternalLocalCommand);
	}
	
	public function removeLocalHandler(message:String):void {
		if (!testView) {
			testView = new ExternalView();
			mediatorMap.mediate(testView);
		}
		testView.removeLocalhandler(message);
	}
	
	public function removeRemoteCommand(message:String):void {
		commandMap.unmapRemote(message, ExternalRemoteCommand, SuiteModuleNames.MAIN_MODULE);
	}
	
	public function removeRemoteHandler(message:String):void {
		if (!testView) {
			testView = new ExternalView();
			mediatorMap.mediate(testView);
		}
		testView.removeRemoteHandler(message);
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