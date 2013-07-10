package integration.aGenericTestObjects.model {
import mvcexpress.mvc.Proxy;

public class GenericTestProxy_withInject extends Proxy {

	[Inject]
	public var genericTestProxy:GenericTestProxy;

	public function GenericTestProxy_withInject() {

	}

	override protected function onRegister():void {

	}

	override protected function onRemove():void {

	}

}
}