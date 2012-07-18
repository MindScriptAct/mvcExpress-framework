package suites.featureProxyHost.testObjects.localObjects {
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class LocalProxyWithLocalInjection extends Proxy {
	
	static public var injectedProxy:HostProxy;
	
	[Inject]
	public var hostProxy:HostProxy;
	
	public function LocalProxyWithLocalInjection() {
	}
	
	override protected function onRegister():void {
		injectedProxy = hostProxy;
	}
	
	override protected function onRemove():void {
	
	}

}
}