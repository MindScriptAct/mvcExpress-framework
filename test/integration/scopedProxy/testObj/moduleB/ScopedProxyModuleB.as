package integration.scopedProxy.testObj.moduleB {
import flash.display.Sprite;
import flash.events.Event;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ScopedProxyModuleB extends ModuleCore {
	private var view:Sprite;
	private var testViewObject:ScopedProxyInjectView;
	private var testProxy:ScopedProxyInjectProxy;
	
	static public const NAME:String = "ScopedProxyModuleB";
	
	static public var TEST_FUNCTION:Function = function(msg:*):void {
		trace( "TEST_FUNCTION : " + TEST_FUNCTION );
	};
	
	public function ScopedProxyModuleB() {
		super(ScopedProxyModuleB.NAME);
	}
	
	public function createMediatorWithItject():void {
		testViewObject = new ScopedProxyInjectView();
		
		mediatorMap.map(ScopedProxyInjectView, ScopedProxyInjectMediator);
		mediatorMap.mediate(testViewObject);
	}
	
	public function storeStuffToMediator(testData:String):void {
		testViewObject.sendDataToProxy(testData);
	}
	
	public function createProxyWithItject():void {
		testProxy = new ScopedProxyInjectProxy();
		proxyMap.map(testProxy);
	}
	
	public function storeStuffToProxy(testData:String):void {
		testProxy.storeTestData(testData);
	}
	
	public function storeStuffToCommand(testData:String):void {
	
	}
	
	public function getMediatorProxyTestData():String {
		return "";
	}
	
	override protected function onInit():void {
	
	}
	
	override protected function onDispose():void {
	
	}
}
}