package integration.scopedProxy.testObj.moduleA {
import flash.display.Sprite;

/**
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ScopedProxyLocalInjectView extends Sprite {
	
	private var scopedProxyLocalInjectMediator:ScopedProxyLocalInjectMediator;
	
	public function pushMediatorIn(scopedProxyLocalInjectMediator:ScopedProxyLocalInjectMediator):void {
		this.scopedProxyLocalInjectMediator = scopedProxyLocalInjectMediator;
	
	}
	
	public function sendDataToProxy(testData:String):void {
		scopedProxyLocalInjectMediator.sendDataToProxy(testData);
	}
}
}