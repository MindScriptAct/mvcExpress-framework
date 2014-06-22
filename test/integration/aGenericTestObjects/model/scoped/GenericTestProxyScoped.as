package integration.aGenericTestObjects.model.scoped {
import integration.aGenericTestObjects.model.*;

import mvcexpress.extensions.scoped.mvc.ProxyScoped;

import mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericTestProxyScoped extends ProxyScoped implements IGenericTestProxy {

	public var testData:String;
	private var onRegisterMessage:String;

	public static var ASYNC_REGISTER_FUNCTION:Function;

	public function GenericTestProxyScoped(onRegisterMessage:String = null) {
		this.onRegisterMessage = onRegisterMessage;

	}

	override protected function onRegister():void {
		if (onRegisterMessage) {
			sendMessage(onRegisterMessage);
		}
		if (ASYNC_REGISTER_FUNCTION != null) {
			ASYNC_REGISTER_FUNCTION();
		}
	}

	override protected function onRemove():void {

	}


	public function sendMessageTest(type:String, params:Object = null):void {
		super.sendMessage(type, params);
	}
}
}