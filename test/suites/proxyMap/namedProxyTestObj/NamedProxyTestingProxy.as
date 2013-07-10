package suites.proxyMap.namedProxyTestObj {
import mvcexpress.mvc.Proxy;

import suites.proxyMap.proxyTestObj.ITestProxy;
import suites.proxyMap.proxyTestObj.TestProxy;

/**
 * COMMENT
 * @author
 */
public class NamedProxyTestingProxy extends Proxy {

	[Inject]
	public var proxy:TestProxy;

	[Inject]
	public var proxyInterface:ITestProxy;

	[Inject(name="namedProxyInterface")]
	public var proxyNamedInterface:ITestProxy;

	[Inject(name="namedProxy")]
	public var proxyNamed:TestProxy;

	[Inject(name="namedProxyNotNullClass")]
	public var proxyNamedNotNullClass:TestProxy;

}
}