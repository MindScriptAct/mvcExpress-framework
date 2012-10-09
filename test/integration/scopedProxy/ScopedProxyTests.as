package integration.scopedProxy {
import integration.scopedProxy.testObj.moduleA.ScopedProxyModuleA;
import integration.scopedProxy.testObj.moduleA.ScopedTestProxy;
import integration.scopedProxy.testObj.moduleB.ScopedProxyModuleB;
import org.flexunit.Assert;
import org.mvcexpress.MvcExpress;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author
 */
public class ScopedProxyTests {
	private var scopedProxyModuleA:ScopedProxyModuleA;
	private var scopedProxyModuleB:ScopedProxyModuleB;
	private var scopedTestProxy:ScopedTestProxy;
	
	private var randomData:String;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		scopedProxyModuleA = new ScopedProxyModuleA();
		scopedProxyModuleB = new ScopedProxyModuleB();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		scopedTestProxy = null;
		scopedProxyModuleA.disposeModule();
		scopedProxyModuleB.disposeModule();
		MvcExpress.pendingInjectsTimeOut = 0;
	}
	
	// A host
	// B inject to mediator
	// inject ok
	
	[Test(async)]
	[Ignore]
	
	public function scopedProxy_hostAndInjectHostedToMediator_injectOk():void {
		scopedTestProxy = new ScopedTestProxy();
		ScopedProxyModuleB.TEST_FUNCTION = AsyncUtil.asyncHandler(this, checkMediator, null, 500, failMediatorCheck)
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleB.createMediatorWithItject();
	}
	
	public function failMediatorCheck(obj:* = null):void {
		Assert.fail("MediatorCheck timed out.");
	}
	
	private function checkMediator(obj:* = null):void {
		scopedProxyModuleB.storeStuffToMediator("storedTestContent");
		Assert.assertEquals(" Mediator should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// A host
	// B inject to mediator
	// inject ok
	// dispose modules
	// create modules
	// A host
	// B inject to mediator
	// inject ok	
	
	[Test(async)]
	[Ignore]
	
	public function scopedProxy_hostAndInjectHostedToMediatorTwice_injectOk():void {
		scopedTestProxy = new ScopedTestProxy();
		
		ScopedProxyModuleB.TEST_FUNCTION = AsyncUtil.asyncHandler(this, checkMediator2, null, 500, failMediatorCheck)
		
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		scopedProxyModuleA.disposeModule();
		scopedProxyModuleB.disposeModule();
		
		scopedProxyModuleA = new ScopedProxyModuleA();
		scopedProxyModuleB = new ScopedProxyModuleB();
		
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleB.createMediatorWithItject();
	}
	
	private function checkMediator2(obj:* = null):void {
		scopedProxyModuleB.storeStuffToMediator("storedTestContent 2");
		Assert.assertEquals(" Mediator should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent 2");
	}
	
	// A host
	// B inject to proxy
	// inject ok
	
	[Test]
	
	public function scopedProxy_hostAndInjectHostedToProxy_injectOk():void {
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleB.createProxyWithItject();
		
		randomData = "storedTestContent" + (Math.random() * 10000000);
		
		scopedProxyModuleB.storeStuffToProxy(randomData);
		
		Assert.assertEquals(" Proxy should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, randomData);
	}
	
	// A host
	// B inject to proxy
	// inject ok
	// dispose modules
	// create modules
	// A host
	// B inject to proxy
	// inject ok	
	
	[Test]
	
	public function scopedProxy_hostAndInjectHostedToProxyTwice_injectOk():void {
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleB.createProxyWithItject();
		
		randomData = "storedTestContent" + (Math.random() * 10000000);
		
		scopedProxyModuleB.storeStuffToProxy(randomData);
		
		scopedProxyModuleA.disposeModule();
		scopedProxyModuleB.disposeModule();
		
		scopedProxyModuleA = new ScopedProxyModuleA();
		scopedProxyModuleB = new ScopedProxyModuleB();
		
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleB.createProxyWithItject();
		
		randomData = "storedTestContent" + (Math.random() * 10000000);
		
		scopedProxyModuleB.storeStuffToProxy(randomData);
		
		Assert.assertEquals(" Proxy should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, randomData);
	
	}
	
	// A host
	// B inject to command
	// inject ok
	
	[Test]
	[Ignore]
	
	public function scopedProxy_hostAndInjectHostedToCommand_injectOk():void {
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		scopedProxyModuleB.storeStuffToCommand("storedTestContent");
		
		Assert.assertEquals(" Command should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// B inject
	// inject fail
	
	[Test(expects="Error")]
	[Ignore]
	
	public function scopedProxy_injectHosted_injectFails():void {
		scopedProxyModuleB.createMediatorWithItject();
	}
	
	// A host
	// A unhost
	// B inject
	// inject fail
	
	[Test(expects="Error")]
	
	public function scopedProxy_hostThenUnhostAndInjectHosted_injectFails():void {
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleA.unhostTestProxy(ScopedTestProxy);
		scopedProxyModuleB.createProxyWithItject();
	}
	
	//
	// A host
	// B inject
	// A send message
	// B get message
	
	[Test]
	[Ignore]
	
	public function scopedProxy_hostAndInjectThenMessage_communicatinOk():void {
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleB.createMediatorWithItject();
		scopedProxyModuleA.trigerMediatorMessage("testMessageData");
		
		Assert.assertEquals(" Mediator should be able to inject hosted proxy, and manipulate it.", scopedProxyModuleB.getMediatorProxyTestData(), "testMessageData");
	}
	
	// pending on
	// B inject
	// A host
	// inject ok
	[Test]
	[Ignore]
	
	public function scopedProxy_injectPendingProxyToMediatorThenHost_injectOk():void {
		MvcExpress.pendingInjectsTimeOut = 1000;
		scopedProxyModuleB.createMediatorWithItject();
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		scopedProxyModuleB.storeStuffToMediator("storedTestContent");
		
		Assert.assertEquals(" Mediator should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// pending on
	// B inject
	// A host
	// inject ok
	[Test]
	[Ignore]
	
	public function scopedProxy_injectPendingProxyToProxyThenHost_injectOk():void {
		MvcExpress.pendingInjectsTimeOut = 1000;
		scopedProxyModuleB.createProxyWithItject();
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		scopedProxyModuleB.storeStuffToProxy("storedTestContent");
		
		Assert.assertEquals(" Proxy should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// pending on
	// B inject
	// A host
	// inject ok
	[Test]
	[Ignore]
	
	public function scopedProxy_injectPendingProxyToCommandThenHost_injectOk():void {
		MvcExpress.pendingInjectsTimeOut = 1000;
		scopedProxyModuleB.storeStuffToCommand("storedTestContent");
		scopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		Assert.assertEquals(" Command should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}

}
}