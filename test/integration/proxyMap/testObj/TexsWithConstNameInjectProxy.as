package integration.proxyMap.testObj {
import integration.aGenericTestObjects.genericObjects.GenericTestProxy;
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class TexsWithConstNameInjectProxy extends Proxy{
	
	
	[Inject (constName="integration.proxyMap.testObj::TestConstObject.TEST_CONST_FOR_PROXY_INJECT", constScope="integration.proxyMap.testObj::TestConstObject.TEST_CONST_FOR_PROXY_INJECT")]
	public var genericTestProxy:GenericTestProxy;
	
	
	public function TexsWithConstNameInjectProxy(){
		
	}
	
	override protected function onRegister():void{
	
	}
	
	override protected function onRemove():void{
	
	}

}
}