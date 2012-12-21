package integration.aGenericTestObjects {
import integration.proxyMap.testObj.CestConstCommand;
import integration.proxyMap.testObj.TestContsViewMediator;
import flash.display.Sprite;
import flash.events.Event;
import integration.aGenericTestObjects.genericObjects.GenericTestProxy;
import integration.lazyProxy.LazyProxyTests;
import integration.proxyMap.testObj.TestContsView;
import org.mvcexpress.modules.ModuleCore;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class GenericTestModule extends ModuleCore {
	
	public function GenericTestModule(moduleName:String) {
		super(moduleName);
	}
	
	public function mapProxy(testProxy:Proxy, injectClass:Class = null, proxyName:String = ""):void {
		proxyMap.map(testProxy, injectClass, proxyName);
	}
	
	public function mapMediatorWith(view:Object, mediatorClass:Class, injectClass:Class = null):void {
		mediatorMap.mediateWith(view, mediatorClass, injectClass);
	}
	
	public function execute(commandClass:Class):void {
		commandMap.execute(commandClass);
	}

	//public function lazyMap():void {
	//proxyMap.lazyMap();
	//}
	//
	//public function normalMap():void {
	//proxyMap.map(new LazyProxy());
	//}
	//
	//public function createProxyWithLazyInject():void {
	//proxyMap.map(new LazyNormalProxy());
	//}
	//
	//public function mapNotProxy():void {
	//proxyMap.lazyMap(Sprite);
	//}
	//
	//public function mapWithParams(params:Array):void {
	//proxyMap.lazyMap(LazyProxy, null, "", params);
	//}

}
}