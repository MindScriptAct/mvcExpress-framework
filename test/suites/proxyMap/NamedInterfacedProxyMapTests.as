package suites.proxyMap {
import constants.TestExtensionDict;
import integration.aframworkHelpers.ProxyMapCleaner;

import flexunit.framework.Assert;

import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

import suites.proxyMap.namedProxyTestObj.NamedProxyTestingProxy;
import suites.proxyMap.proxyTestObj.ITestProxy;
import suites.proxyMap.proxyTestObj.TestProxy;

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

		Messenger.allowInstantiation = true;
		messenger = new Messenger("test");
		Messenger.allowInstantiation = false;
		proxyMap = new ProxyMap("test", messenger);

		CONFIG::debug {
			messenger.setSupportedExtensions(TestExtensionDict.getDefaultExtensionDict());
			proxyMap.setSupportedExtensions(TestExtensionDict.getDefaultExtensionDict());
		}

	}

	[After]

	public function runAfterEveryTest():void {
		use namespace pureLegsCore;

		ProxyMapCleaner.clear();
		
		messenger = null;
		proxyMap = null;
	}

	[Test]

	public function class_proxy_not_null():void {
		use namespace pureLegsCore;

		proxyMap.map(new TestProxy());

		proxyMap.map(new TestProxy(), null, ITestProxy);
		proxyMap.map(new TestProxy(), "namedProxyInterface", ITestProxy);

		proxyMap.map(new TestProxy(), "namedProxy", null);
		proxyMap.map(new TestProxy(), "namedProxyNotNullClass", TestProxy);

		namedTestingProxy = new NamedProxyTestingProxy();
		proxyMap.injectStuff(namedTestingProxy, NamedProxyTestingProxy);

		Assert.assertNotNull(namedTestingProxy.proxy);

		Assert.assertNotNull(namedTestingProxy.proxyNamedNotNullClass);

		Assert.assertNotNull(namedTestingProxy.proxyInterface);

		Assert.assertNotNull(namedTestingProxy.proxyNamed);

		Assert.assertNotNull(namedTestingProxy.proxyNamedInterface);
	}

}
}