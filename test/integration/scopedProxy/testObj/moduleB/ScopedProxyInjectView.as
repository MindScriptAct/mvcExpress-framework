package integration.scopedProxy.testObj.moduleB {
import flash.display.Sprite;

/**
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ScopedProxyInjectView extends Sprite {
	
	private var scopedProxyInjectMediator:ScopedProxyInjectMediator;
	
	public function pushMediatorIn(scopedProxyInjectMediator:ScopedProxyInjectMediator):void {
		this.scopedProxyInjectMediator = scopedProxyInjectMediator;
	
	}
	
	public function sendDataToProxy(testData:String):void {
		scopedProxyInjectMediator.sendDataToProxy(testData);
	}
}
}