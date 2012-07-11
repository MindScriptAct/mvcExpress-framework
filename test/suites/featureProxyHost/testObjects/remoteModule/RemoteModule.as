package suites.featureProxyHost.testObjects.remoteModule {
import org.mvcexpress.core.ModuleSprite;
import org.mvcexpress.mvc.Proxy;
import suites.featureProxyHost.testObjects.localObjects.HostProxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class RemoteModule extends ModuleSprite {
	private var remoteProxyWithHostedDependency:RemoteProxyWithHostedDependency;
	private var remoteProxyWithNormalInject:RemoteProxyWithNormalInject;
	
	public function RemoteModule() {
		super("remoteModule", true, false);
	}
	
	override protected function onInit():void {
		mediatorMap.map(RemoteViewTest, RemoteViewTestMediator);
		var remoteViewTest:RemoteViewTest = new RemoteViewTest();
		mediatorMap.mediate(remoteViewTest);
	}
	
	///
	
	public function createProxyWithHostedDependency():void {
		remoteProxyWithHostedDependency = new RemoteProxyWithHostedDependency();
	}
	
	public function mapProxyWithHostedDependency():void {
		proxyMap.map(remoteProxyWithHostedDependency);
	}
	
	///
	
	public function createProxyWithNormalInject():void {
		remoteProxyWithNormalInject = new RemoteProxyWithNormalInject();
	}
	
	public function mapProxyWithNormalInject():void {
		proxyMap.map(remoteProxyWithNormalInject);
	}	
	
	///
	
	public function getProxyHostDependency():HostProxy {
		return remoteProxyWithHostedDependency.getHostProxy();
	}
	
	///
	
	public function mapProxy(proxy:Proxy):void {
		proxyMap.map(proxy);
	}
	
	public function messageHandled():Boolean {
		return false;
	}

}
}