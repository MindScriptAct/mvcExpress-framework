package integration.aGenericTestObjects.model {
import mvcexpress.extensions.scoped.mvc.ProxyScoped;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericTestProxy extends ProxyScoped {

	public var testData:String;

	public function GenericTestProxy() {

	}

	override protected function onRegister():void {

	}

	override protected function onRemove():void {

	}


	public function sendMessageTest(type:String, params:Object = null):void {
		super.sendMessage(type, params);
	}
}
}