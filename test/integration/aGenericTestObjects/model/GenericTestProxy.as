package integration.aGenericTestObjects.model {
import org.mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericTestProxy extends Proxy {
	
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