package integration.aGenericTestObjects.model {
import org.mvcexpress.mvc.Proxy;

public class GenericTestProxy_withScopedInject extends Proxy {
	
	[Inject(scope="GenericScopeIds_testScope")]
	public var genericTestProxy:GenericTestProxy;
	
	public function GenericTestProxy_withScopedInject() {
	
	}
	
	override protected function onRegister():void {
	
	}
	
	override protected function onRemove():void {
	
	}

}
}