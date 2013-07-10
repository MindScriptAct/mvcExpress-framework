package integration.proxyMap.testObj {
import integration.aGenericTestObjects.model.GenericTestProxy;
import mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class TexsWithConstNameInjectProxy extends Proxy {

	[Inject(constName="integration.proxyMap.testObj::TestConstObject.TEST_CONST_FOR_PROXY_INJECT")]
	public var genericTestProxy:GenericTestProxy;

	public function TexsWithConstNameInjectProxy() {

	}

	override protected function onRegister():void {

	}

	override protected function onRemove():void {

	}

}
}