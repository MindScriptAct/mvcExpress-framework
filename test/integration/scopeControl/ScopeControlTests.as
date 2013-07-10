package integration.scopeControl {
import integration.aGenericTestObjects.GenericTestModule;
import integration.aGenericTestObjects.constants.GenericScopeIds;
import integration.aGenericTestObjects.constants.GenericTestMessage;
import integration.aGenericTestObjects.constants.GenericTestStrings;
import integration.aGenericTestObjects.controller.GenericCommand;
import integration.aGenericTestObjects.model.GenericTestProxy;
import integration.aGenericTestObjects.view.GenericViewObject;
import integration.aGenericTestObjects.view.GenericViewObjectMediator_handlingScopeMessage;
import integration.aGenericTestObjects.view.GenericViewObjectMediator_withScopedInject_handlingScopeMessage;

import org.flexunit.Assert;

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

	//----------------------------------
	//     should fail without registering
	//----------------------------------

	[Test(expects="Error")]

	public function scopeControl_messageOutWithoutScopeRegister_fails():void {
		moduleOut.sendScopeMessageTest(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE);
	}

	[Test(expects="Error")]

	public function scopeControl_messageInHandleWithoutScopeRegister_fails():void {
		moduleIn.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_handlingScopeMessage);
	}

	[Test(expects="Error")]

	public function scopeControl_messageInCommandMapWithoutScopeRegister_fails():void {
		moduleIn.commandMap_scopeMap(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE, GenericCommand);
	}

	[Test(expects="Error")]

	public function scopeControl_scopedInjectWithoutScopeRegister_fails():void {
		moduleIn.proxymap_scopeMap(GenericScopeIds.TEST_SCOPE, new GenericTestProxy());
	}

	//----------------------------------
	//     should be ok after registernig
	//----------------------------------

	[Test]

	public function scopeControl_messageOutWithScopeRegister_ok():void {
		moduleOut.registerScopeTest(GenericScopeIds.TEST_SCOPE, true, false, false);
		moduleOut.sendScopeMessageTest(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE);
	}

	[Test]

	public function scopeControl_messageInHandleWithScopeRegister_ok():void {
		moduleIn.registerScopeTest(GenericScopeIds.TEST_SCOPE, false, true, false);
		moduleIn.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_handlingScopeMessage);
	}

	[Test]

	public function scopeControl_messageInCommandMapWithScopeRegister_ok():void {
		moduleIn.registerScopeTest(GenericScopeIds.TEST_SCOPE, false, true, false);
		moduleIn.commandMap_scopeMap(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE, GenericCommand);
	}

	[Test]

	public function scopeControl_scopedInjectWithScopeRegister_ok():void {
		moduleIn.registerScopeTest(GenericScopeIds.TEST_SCOPE, false, false, true);
		moduleIn.proxymap_scopeMap(GenericScopeIds.TEST_SCOPE, new GenericTestProxy());
	}

	//----------------------------------
	//     should fail if module removed and added without registering
	//----------------------------------

	[Test(expects="Error")]

	public function scopeControl_messageOutWithScopeRegisterWithModuleRecreate_fails():void {
		moduleOut.registerScopeTest(GenericScopeIds.TEST_SCOPE, true, false, false);
		moduleOut.disposeModule();
		moduleOut = new GenericTestModule("moduleOut");
		moduleOut.sendScopeMessageTest(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE);
	}

	[Test(expects="Error")]

	public function scopeControl_messageInHandleWithScopeRegisterWithModuleRecreate_fails():void {
		moduleIn.registerScopeTest(GenericScopeIds.TEST_SCOPE, false, true, false);
		moduleIn.disposeModule();
		moduleIn = new GenericTestModule("moduleIn");
		moduleIn.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_handlingScopeMessage);
	}

	[Test(expects="Error")]

	public function scopeControl_messageInCommandMapWithScopeRegisterWithModuleRecreate_fails():void {
		moduleIn.registerScopeTest(GenericScopeIds.TEST_SCOPE, false, true, false);
		moduleIn.disposeModule();
		moduleIn = new GenericTestModule("moduleIn");
		moduleIn.commandMap_scopeMap(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE, GenericCommand);
	}

	[Test(expects="Error")]

	public function scopeControl_scopedInjectWithScopeRegisterWithModuleRecreate_fails():void {
		moduleIn.registerScopeTest(GenericScopeIds.TEST_SCOPE, false, false, true);
		moduleIn.disposeModule();
		moduleIn = new GenericTestModule("moduleIn");
		moduleIn.proxymap_scopeMap(GenericScopeIds.TEST_SCOPE, new GenericTestProxy());
	}

	//----------------------------------
	//     misc
	//----------------------------------

	/// test can send and receive

	[Test]

	public function scopeControl_messageOutAndInWithScopeRegister_ok():void {
		moduleOut.registerScopeTest(GenericScopeIds.TEST_SCOPE, true, true, false);
		moduleOut.sendScopeMessageTest(GenericScopeIds.TEST_SCOPE, GenericTestMessage.TEST_MESSAGE);
		moduleOut.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_handlingScopeMessage);
	}

	// inject porxy, and force it to send message on change... - not fail with receiving enabled.

	[Test]

	public function scopeControl_injectedProxyChangeShouldBeHandled_ok():void {

		var testProxy:GenericTestProxy = new GenericTestProxy();

		// set up module out
		moduleOut.registerScopeTest(GenericScopeIds.TEST_SCOPE, false, false, true);
		moduleOut.proxymap_scopeMap(GenericScopeIds.TEST_SCOPE, testProxy);

		// set up moduleIn
		moduleIn.registerScopeTest(GenericScopeIds.TEST_SCOPE, false, true, false);
		moduleIn.mediatorMap_mediateWith(new GenericViewObject(), GenericViewObjectMediator_withScopedInject_handlingScopeMessage);

		// triger proxy.
		testProxy.sendMessageTest(GenericTestMessage.TEST_MESSAGE);

		// test data.
		Assert.assertEquals("remote proxy should react to message and set data.", testProxy.testData, GenericTestStrings.data1);

	}


}
}