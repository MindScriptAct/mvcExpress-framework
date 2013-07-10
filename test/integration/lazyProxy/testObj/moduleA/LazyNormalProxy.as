package integration.lazyProxy.testObj.moduleA {
import mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author rbanevicius
 */
public class LazyNormalProxy extends Proxy{

	[Inject]
	public var lazyProxy:LazyProxy;

	public function LazyNormalProxy(){

	}

	override protected function onRegister():void{

	}

	override protected function onRemove():void{

	}

}
}