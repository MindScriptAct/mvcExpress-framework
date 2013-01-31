package integration.scopeControl {
import integration.aGenericTestObjects.GenericTestModule;
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
public class ScopeControlTests {
	
	private var moduleOut:GenericTestModule;
	private var moduleIn:GenericTestModule;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		moduleOut = new GenericTestModule("moduleOut");
		moduleIn = new GenericTestModule("moduleIn");
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		moduleOut.disposeModule();
		moduleIn.disposeModule();
	}
	
	[Test]
	
	public function scopeControl_messageOutWithoutScopeMap_fails():void {
	
	}
	
	[Test]
	
	public function scopeControl_messageInHandleWithoutScopeMap_fails():void {
	
	}
	
	[Test]
	
	public function scopeControl_messageInCommandMapWithoutScopeMap_fails():void {
	
	}

}
}