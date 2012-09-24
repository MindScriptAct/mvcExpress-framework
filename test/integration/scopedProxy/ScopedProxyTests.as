package integration.scopedProxy {
import integration.scopedProxy.testObj.moduleA.ScopedProxyModuleA;
import integration.scopedProxy.testObj.moduleA.ScopedTestProxy;
import integration.scopedProxy.testObj.moduleB.ScopedProxyModuleB;
import org.flexunit.Assert;
import org.mvcexpress.MvcExpress;

/**
 * COMMENT
 * @author
 */
public class ScopedProxyTests {
	private var scopedProxyModuleA:ScopedProxyModuleA;
	private var scopedProxyModuleB:ScopedProxyModuleB;
	;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		scopedProxyModuleA = new ScopedProxyModuleA();
		scopedProxyModuleB = new ScopedProxyModuleB();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		scopedProxyModuleA.disposeModule();
		scopedProxyModuleB.disposeModule();
		MvcExpress.pendingInjectsTimeOut = 0;
	}
	
	// A host
	// B inject to mediator
	// inject ok
	
	[Test]
	
	public function scopedProxy_hostAndInjectHostedToMediator_injectOk():void {
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleB.createMediatorWithItject();
		
		scopedProxyModuleB.storeStuffToMediator("storedTestContent");
		
		Assert.assertEquals(" Mediator should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// A host
	// B inject to proxy
	// inject ok
	
	[Test]
	
	public function scopedProxy_hostAndInjectHostedToProxy_injectOk():void {
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleB.createProxyWithItject();
		
		scopedProxyModuleB.storeStuffToProxy("storedTestContent");
		
		Assert.assertEquals(" Proxy should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// A host
	// B inject to command
	// inject ok
	
	[Test]
	
	public function scopedProxy_hostAndInjectHostedToCommand_injectOk():void {
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		scopedProxyModuleB.storeStuffToCommand("storedTestContent");
		
		Assert.assertEquals(" Command should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// B inject
	// inject fail
	
	[Test(expects="Error")]
	
	public function scopedProxy_injectHosted_injectFails():void {
		scopedProxyModuleB.createMediatorWithItject();
	}
	
	// A host
	// A unhost
	// B inject
	// inject fail
	
	[Test(expects="Error")]
	
	public function scopedProxy_hostThenUnhostAndInjectHosted_injectFails():void {
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		scopedProxyModuleA.unhostTestProxy();
		scopedProxyModuleB.createMediatorWithItject();
	}
	
	// 
	// A host
	// B inject
	// A send message
	// B get message
	
	[Test]
	
	public function scopedProxy_hostAndInjectThenMessage_communicatinOk():void {
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
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
	
	public function scopedProxy_injectPendingProxyToMediatorThenHost_injectOk():void {
		MvcExpress.pendingInjectsTimeOut = 1000;
		scopedProxyModuleB.createMediatorWithItject();
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		scopedProxyModuleB.storeStuffToMediator("storedTestContent");
		
		Assert.assertEquals(" Mediator should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// pending on 
	// B inject
	// A host
	// inject ok
	[Test]
	
	public function scopedProxy_injectPendingProxyToProxyThenHost_injectOk():void {
		MvcExpress.pendingInjectsTimeOut = 1000;
		scopedProxyModuleB.createProxyWithItject();
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		scopedProxyModuleB.storeStuffToProxy("storedTestContent");
		
		Assert.assertEquals(" Proxy should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}
	
	// pending on 
	// B inject
	// A host
	// inject ok
	[Test]
	
	public function scopedProxy_injectPendingProxyToCommandThenHost_injectOk():void {
		MvcExpress.pendingInjectsTimeOut = 1000;
		scopedProxyModuleB.storeStuffToCommand("storedTestContent");
		var scopedTestProxy:ScopedTestProxy = new ScopedTestProxy();
		scopedProxyModuleA.hostTestProxy(scopedTestProxy);
		
		
		Assert.assertEquals(" Command should be able to inject hosted proxy, and manipulate it.", scopedTestProxy.storedData, "storedTestContent");
	}

}
}