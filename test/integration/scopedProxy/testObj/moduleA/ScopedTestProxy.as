package integration.scopedProxy.testObj.moduleA {
import integration.scopedProxy.ScopedProxyTests;
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ScopedTestProxy extends Proxy {
	public var storedData:String;
	
	public function ScopedTestProxy() {
	
	}
	

	
	override protected function onRegister():void {
	
	}
	
	override protected function onRemove():void {
	
	}
	
	
	public function trigerMessage(messagedata:String):void {
		sendMessage(ScopedProxyTests.SCOPED_PROXY_MESSAGE_NAME, messagedata);
	}
}
}