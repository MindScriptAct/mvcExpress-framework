package integration.scopedProxy.testObj.moduleB {
import flash.display.Sprite;

/**
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ScopedProxyInjectView extends Sprite {
	
	public var testData:String;
	
	private var scopedProxyInjectMediator:ScopedProxyInjectMediator;
	
	public function pushMediatorIn(scopedProxyInjectMediator:ScopedProxyInjectMediator):void {
		trace( "ScopedProxyInjectView.pushMediatorIn > scopedProxyInjectMediator : " + scopedProxyInjectMediator );
		this.scopedProxyInjectMediator = scopedProxyInjectMediator;
	
	}
	
	public function sendDataToProxy(testData:String):void {
		trace( "ScopedProxyInjectView.sendDataToProxy > testData : " + testData );
		trace( "scopedProxyInjectMediator : " + scopedProxyInjectMediator );
		scopedProxyInjectMediator.sendDataToProxy(testData);
	}
}
}