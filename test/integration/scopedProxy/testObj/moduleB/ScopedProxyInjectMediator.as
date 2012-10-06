package integration.scopedProxy.testObj.moduleB{
import flash.display.Sprite;
import integration.scopedProxy.testObj.moduleA.ScopedTestProxy;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ScopedProxyInjectMediator extends Mediator {
	
	[Inject]
	public var view:ScopedProxyInjectView;
	
	[Inject (scope="proxyScope")]
	public var myProxy:ScopedTestProxy;
	
	override public function onRegister():void {
		view.pushMediatorIn(this);
	}
	
	override public function onRemove():void {
		
	}
	
	public function sendDataToProxy(testData:String):void {
		myProxy.storedData = testData;
	}
	
}
}