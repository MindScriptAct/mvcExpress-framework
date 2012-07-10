package suites.featureProxyHost.testObjects {
import org.mvcexpress.core.ModuleSprite;
import org.mvcexpress.mvc.Proxy;
import suites.featureProxyHost.testObjects.localObjects.HostProxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class HostTestModuleSprite extends ModuleSprite {
	
	public function HostTestModuleSprite() {
	
	}
	
	public function hostTestProxy(classToHost:Class, name:String = ""):void {
		hostProxy(classToHost, name);
	}
	
	public function unhostTestProxy(classToHost:Class, name:String = ""):void {
		unhostProxy(classToHost, name);
	}
	
	public function mapProxy(hostProxy:Proxy):void {
		proxyMap.map(hostProxy);
	}

}
}