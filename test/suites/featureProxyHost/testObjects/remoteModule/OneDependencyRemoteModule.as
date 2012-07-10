package suites.featureProxyHost.testObjects.remoteModule {
import flash.utils.Proxy;
import org.mvcexpress.core.ModuleSprite;
import suites.featureProxyHost.testObjects.localObjects.HostProxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class OneDependencyRemoteModule extends ModuleSprite {
	private var firstProxy:OneDependencyRemoteProxy;
	
	public function OneDependencyRemoteModule() {
	
	}
	
	override protected function onInit():void {
	}
	
	public function createFirstProxy():void {
		firstProxy = new OneDependencyRemoteProxy();
	}
	
	public function mapFirstProxy():void {
		proxyMap.map(firstProxy);
	}
	
	public function getProxyHostDependency():HostProxy {
		return firstProxy.getHostProxy();
	}

}
}