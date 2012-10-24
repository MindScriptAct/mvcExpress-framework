package integration.lazyProxy {
import flexunit.framework.Assert;
import integration.lazyProxy.testObj.moduleA.LazyProxy;
import integration.lazyProxy.testObj.moduleA.LazyProxyModuleA;

/**
 * COMMENT
 * @author
 */
public class LazyProxyTests {
	private var lazyProxyModulA:LazyProxyModuleA;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		lazyProxyModulA = new LazyProxyModuleA();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		lazyProxyModulA.disposeModule();
		LazyProxy.instantiateCount = 0;
	}
	
	[Test]
	
	public function lazyProxy_lazyMaping_proxyNotInstantiated():void {
		lazyProxyModulA.lazyMap();
		Assert.assertEquals("Lazy mapping should not instantiate proxy.", LazyProxy.instantiateCount, 0);
	}
	
	[Test]
	
	public function lazyProxy_lazyMapingThenInjectingToProxy_proxyInstantiatedOnce():void {
		lazyProxyModulA.lazyMap();
		lazyProxyModulA.createProxyWithLazyInject();
		Assert.assertEquals("Lazy proxy must be instantiated once.", LazyProxy.instantiateCount, 1);
	}	
}
}