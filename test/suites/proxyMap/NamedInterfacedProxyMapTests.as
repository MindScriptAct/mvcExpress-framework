package suites.proxyMap {
import flexunit.framework.Assert;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;
import suites.proxyMap.proxyTestObj.ITestProxy;
import suites.proxyMap.proxyTestObj.TestProxy;
import suites.proxyMap.namedProxyTestObj.NamedProxyTestingProxy;

/**
 * COMMENT
 * @author
 */
public class NamedInterfacedProxyMapTests {
	private var messenger:Messenger;
	private var proxyMap:ProxyMap;
	private var namedTestingProxy:NamedProxyTestingProxy;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		proxyMap = new ProxyMap(messenger);
	
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		messenger.clear();
		proxyMap = null;
	
	}
	
	[Test]	
	public function class_proxy_not_null():void {
		use namespace pureLegsCore;
		proxyMap.mapClass(TestProxy);
		proxyMap.mapClass(TestProxy, null, "namedClassProxy");
		proxyMap.mapClass(TestProxy, TestProxy, "namedClassProxyNotNullClass");
		proxyMap.mapClass(TestProxy, ITestProxy);
		proxyMap.mapClass(TestProxy, ITestProxy, "namedClassProxyInterface");
		
		proxyMap.mapObject(new TestProxy(), null, "namedObjectProxy");
		proxyMap.mapObject(new TestProxy(), TestProxy, "namedObjectProxyNotNullClass");
		proxyMap.mapObject(new TestProxy(), ITestProxy, "namedObjectProxyInterface");
		
		namedTestingProxy = new NamedProxyTestingProxy();
		proxyMap.injectStuff(namedTestingProxy, NamedProxyTestingProxy);
		
		Assert.assertNotNull(namedTestingProxy.classProxy);
		
		Assert.assertNotNull(namedTestingProxy.classProxy);
		
		Assert.assertNotNull(namedTestingProxy.classProxyNamed);
		
		Assert.assertNotNull(namedTestingProxy.classProxyNamedNotNullClass);
		
		Assert.assertNotNull(namedTestingProxy.classProxyInterface);
		
		Assert.assertNotNull(namedTestingProxy.classProxyNamedInterface);
		
		Assert.assertNotNull(namedTestingProxy.objectProxyNamed);
		
		Assert.assertNotNull(namedTestingProxy.objectProxyNamedNotNullClass);
		
		Assert.assertNotNull(namedTestingProxy.objectProxyNamedInterface);
	}

}
}