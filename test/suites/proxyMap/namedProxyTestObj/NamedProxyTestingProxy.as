package suites.proxyMap.namedProxyTestObj {
import org.mvcexpress.mvc.Proxy;
import suites.proxyMap.proxyTestObj.ITestProxy;
import suites.proxyMap.proxyTestObj.TestProxy;


/**
 * COMMENT
 * @author
 */
public class NamedProxyTestingProxy extends Proxy {
	
	[Inject]
	public var classProxy:TestProxy;
	
	[Inject(name="namedClassProxy")]
	public var classProxyNamed:TestProxy;
	
	[Inject(name="namedClassProxyNotNullClass")]
	public var classProxyNamedNotNullClass:TestProxy;
	
	[Inject]
	public var classProxyInterface:ITestProxy;
	
	[Inject(name="namedClassProxyInterface")]
	public var classProxyNamedInterface:ITestProxy;
	
	[Inject(name="namedObjectProxy")]
	public var objectProxyNamed:TestProxy;
	
	[Inject(name="namedObjectProxyNotNullClass")]
	public var objectProxyNamedNotNullClass:TestProxy;
	
	[Inject(name="namedObjectProxyInterface")]
	public var objectProxyNamedInterface:ITestProxy;

}
}