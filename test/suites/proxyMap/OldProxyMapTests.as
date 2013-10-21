package suites.proxyMap {
import constants.TestExtensionDict;

import flexunit.framework.Assert;

import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

import suites.proxyMap.proxyTestObj.ProxyTestObj;
import suites.proxyMap.proxyTestObj.TestProxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class OldProxyMapTests {

	private var messenger:Messenger;
	private var proxyMap:ProxyMap;
	private var callCaunter:int;
	private var callsExpected:int;

	[Before]

	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;

		Messenger.allowInstantiation = true;
		messenger = new Messenger("test");
		Messenger.allowInstantiation = false;
		proxyMap = new ProxyMap("test", messenger);
		callCaunter = 0;
		callsExpected = 0;

		CONFIG::debug {
			messenger.setSupportedExtensions(TestExtensionDict.getDefaultExtensionDict());
			proxyMap.setSupportedExtensions(TestExtensionDict.getDefaultExtensionDict());
		}
	}

	[After]

	public function runAfterEveryTest():void {
		use namespace pureLegsCore;

		messenger = null;
		proxyMap = null;
		callCaunter = 0;
		callsExpected = 0;
	}

	//----------------------------------
	//
	//----------------------------------

	[Test]

	public function using_class_proxy():void {
		use namespace pureLegsCore;

		proxyMap.map(new TestProxy());
		var obj1:ProxyTestObj = new ProxyTestObj();
		proxyMap.injectStuff(obj1, ProxyTestObj);
		Assert.assertNotNull("Injected object must be not null", obj1.testProxy);
	}

	//----------------------------------
	//
	//----------------------------------

	[Test]

	public function using_class_proxy_twice_both_should_be_equal():void {
		use namespace pureLegsCore;

		proxyMap.map(new TestProxy());
		var obj1:ProxyTestObj = new ProxyTestObj();
		var obj2:ProxyTestObj = new ProxyTestObj();
		proxyMap.injectStuff(obj1, ProxyTestObj);
		proxyMap.injectStuff(obj2, ProxyTestObj);
		Assert.assertEquals("Injected class object must be equel everythere.", obj1.testProxy, obj2.testProxy);
	}

	//----------------------------------
	//
	//----------------------------------

	[Test(expects="Error")]

	public function mapping_class_proxy_twice_throws_error():void {
		proxyMap.map(new TestProxy());
		proxyMap.map(new TestProxy());
	}

	//----------------------------------
	//
	//----------------------------------
	[Test]

	public function using_object_test():void {
		use namespace pureLegsCore;

		var testProxy:TestProxy = new TestProxy();
		proxyMap.map(testProxy, TestProxy);
		var obj1:ProxyTestObj = new ProxyTestObj();
		proxyMap.injectStuff(obj1, ProxyTestObj);
		Assert.assertEquals("Maped value object must be used for iject object.", obj1.testProxy, testProxy);
	}

	//----------------------------------
	//
	//----------------------------------

	[Test]

	public function using_object_proxy_twice_both_should_be_equal():void {
		use namespace pureLegsCore;

		var testProxy:TestProxy = new TestProxy();
		proxyMap.map(testProxy);
		var obj1:ProxyTestObj = new ProxyTestObj();
		var obj2:ProxyTestObj = new ProxyTestObj();
		proxyMap.injectStuff(obj1, ProxyTestObj);
		proxyMap.injectStuff(obj2, ProxyTestObj);
		Assert.assertEquals("Injected value object must be equel everythere.", obj1.testProxy, obj2.testProxy);
	}

	//----------------------------------
	//
	//----------------------------------

	[Test(expects="Error")]

	public function mapping_object_proxy_twice_throws_error():void {
		var testProxy:TestProxy = new TestProxy();
		proxyMap.map(testProxy);
		proxyMap.map(testProxy);
	}

	//----------------------------------
	//
	//----------------------------------
	[Test(expects="Error")]

	public function mappings_does_not_exists_throws_error():void {
		use namespace pureLegsCore;

		var obj1:ProxyTestObj = new ProxyTestObj();
		proxyMap.injectStuff(obj1, ProxyTestObj);
	}

	//----------------------------------
	//
	//----------------------------------
	[Test(expects="Error")]

	public function removing_class_proxy():void {
		use namespace pureLegsCore;

		proxyMap.map(new TestProxy());
		proxyMap.unmap(TestProxy);
		var obj1:ProxyTestObj = new ProxyTestObj();
		proxyMap.injectStuff(obj1, ProxyTestObj);
	}

	//----------------------------------
	//
	//----------------------------------
	[Test(expects="Error")]

	public function removing_object_proxy():void {
		use namespace pureLegsCore;

		var testProxy:TestProxy = new TestProxy();
		proxyMap.map(testProxy);
		proxyMap.unmap(TestProxy);
		var obj1:ProxyTestObj = new ProxyTestObj();
		proxyMap.injectStuff(obj1, ProxyTestObj);
	}

	//----------------------------------
	//     isMapped()
	//----------------------------------

	[Test]

	public function debug_test_isMapped_false():void {
		use namespace pureLegsCore;

		var testProxy:TestProxy = new TestProxy();
		//proxyMap.map(testProxy);
		Assert.assertFalse("isMapped() should retturn false with NOT mapped proxy.", proxyMap.isMapped(TestProxy));
	}

	[Test]

	public function debug_test_isMapped_true():void {
		use namespace pureLegsCore;

		var testProxy:TestProxy = new TestProxy();
		proxyMap.map(testProxy);
		Assert.assertTrue("isMapped() should retturn true with mapped proxy.", proxyMap.isMapped(TestProxy));
	}

	//----------------------------------
	//
	//----------------------------------
	private function callBackFail(obj:* = null):void {
		Assert.fail("CallBack should not be called...");
	}

	public function callBackSuccess(obj:* = null):void {
	}

	//----------------------------------
	//
	//----------------------------------
	private function callBackCheck(obj:* = null):void {
		//trace( "ControllerTests.callBackCheck > obj : " + obj );
		if (callCaunter != callsExpected) {
			Assert.fail("Expected " + callsExpected + " calls, but " + callCaunter + " was received...");
		}
	}

	public function callBackIncrease(obj:* = null):void {
		//trace( "ControllerTests.callBackIncrease > obj : " + obj );
		callCaunter++;
	}

}
}