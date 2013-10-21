package integration.scopedProxy.testObj.moduleA {
import integration.scopedProxy.ScopedProxyTests;

import mvcexpress.extensions.scoped.mvc.ProxyScoped;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class ScopedTestProxy extends ProxyScoped {
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