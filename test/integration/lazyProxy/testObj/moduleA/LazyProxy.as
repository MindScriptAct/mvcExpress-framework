package integration.lazyProxy.testObj.moduleA {
import org.mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author rbanevicius
 */
public class LazyProxy extends Proxy {
	
	public static var instantiateCount:int = 0;
	
	public function LazyProxy() {
		LazyProxy.instantiateCount++;
	}
	
	override protected function onRegister():void {
	
	}
	
	override protected function onRemove():void {
	
	}

}
}