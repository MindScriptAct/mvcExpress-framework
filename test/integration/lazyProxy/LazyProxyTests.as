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
	
	[Test(expects="Error")]
	
	public function lazyProxy_lazyAndNormalMaping_fails():void {
		lazyProxyModulA.lazyMap();
		lazyProxyModulA.normalMap();
	}
	
	[Test(expects="Error")]
	
	public function lazyProxy_normalAndLazyMaping_fails():void {
		lazyProxyModulA.normalMap();
		lazyProxyModulA.lazyMap();
	}
	
	[Test(expects="Error")]
	
	public function lazyProxy_lazyMapingTwice_fails():void {
		lazyProxyModulA.lazyMap();
		lazyProxyModulA.lazyMap();
	}
	
	[Test(expects="Error")]
	
	public function lazyProxy_lazyMapingNotProxy_fails():void {
		CONFIG::debug {
			lazyProxyModulA.mapNotProxy();
			return;
		}
		throw Error("debug mode only.");
	}
	
	//----------------------------------
	//     params
	//----------------------------------
	
	[Test]
	
	public function lazyProxy_lazyMaping1Param_ok():void {
		lazyProxyModulA.mapWithParams([1]);
	}
	
	[Test]
	
	public function lazyProxy_lazyMaping10Params_ok():void {
		lazyProxyModulA.mapWithParams([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
	}
	
	[Test(expects="Error")]
	
	public function lazyProxy_lazyMaping11Params_fails():void {
		CONFIG::debug {
			lazyProxyModulA.mapWithParams([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
		}
		throw Error("debug mode only.");
	}

}
}