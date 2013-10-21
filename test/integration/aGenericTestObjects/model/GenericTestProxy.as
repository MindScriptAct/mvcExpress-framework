package integration.aGenericTestObjects.model {
import mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericTestProxy extends Proxy {

	public var testData:String;
	private var onRegisterMessage:String;

	public function GenericTestProxy(onRegisterMessage:String = null) {
		this.onRegisterMessage = onRegisterMessage;

	}

	override protected function onRegister():void {
		if (onRegisterMessage) {
			sendMessage(onRegisterMessage);
		}
	}

	override protected function onRemove():void {

	}


	public function sendMessageTest(type:String, params:Object = null):void {
		super.sendMessage(type, params);
	}
}
}