package suites.general {
import org.flexunit.Assert;
import org.mvcexpress.mvc.Proxy;
import org.mvcexpress.MvcExpress;
import suites.featureProxyHost.testObjects.HostTestModuleSprite;
import suites.featureProxyHost.testObjects.localObjects.HostProxy;
import suites.featureProxyHost.testObjects.localObjects.HostProxySubclass;
import suites.featureProxyHost.testObjects.localObjects.LocalProxyWithGlobalInjection;
import suites.featureProxyHost.testObjects.localObjects.LocalProxyWithLocalInjection;
import suites.featureProxyHost.testObjects.remoteModule.RemoteModule;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class GeneralTests {
	
	[Before]
	
	public function runBeforeEveryTest():void {
	}
	
	[After]
	
	public function runAfterEveryTest():void {
	}
	
	[Test(description="Version Test")]
	
	public function general_framework_version():void {
		Assert.assertEquals("Version must be defined using 3 numbers, separated by dots.", MvcExpress.VERSION.split(".").length, 3);
	}
	
	[Test(description="Debug flag Test")]
	
	public function general_debug_flag():void {
		CONFIG::debug {
			Assert.assertTrue("While compiling in debug - MvcExpress.DEBUG_COMPILE must be true.", MvcExpress.DEBUG_COMPILE);
			return;
		}
		Assert.assertFalse("While compiling in debug - MvcExpress.DEBUG_COMPILE must be false.", MvcExpress.DEBUG_COMPILE);
	}	
	
}
}