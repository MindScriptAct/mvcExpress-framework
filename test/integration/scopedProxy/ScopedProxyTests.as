package integration.scopedProxy {
import integration.scopedProxy.testObj.moduleA.ScopedProxyModuleA;
import integration.scopedProxy.testObj.moduleB.ScopedProxyModuleB;

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
	}
	
	[Test]
	
	//[Ignore]
	public function scopedProxy_moduleToModuleChanneling_addChannelHandler_sendsMessage():void {
		//
	}

}
}