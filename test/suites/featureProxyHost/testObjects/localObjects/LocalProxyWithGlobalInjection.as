package suites.featureProxyHost.testObjects.localObjects {
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class LocalProxyWithGlobalInjection extends Proxy {
	
	static public var injectedProxy:HostProxy;
	
	[Inject(isHosted=true)]
	public var hostProxy:HostProxy;
	
	public function LocalProxyWithGlobalInjection() {
	}
	
	override protected function onRegister():void {
		injectedProxy = hostProxy;
	}
	
	override protected function onRemove():void {
	
	}

}
}