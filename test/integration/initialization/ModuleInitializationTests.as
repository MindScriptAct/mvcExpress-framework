package integration.initialization {
import flexunit.framework.Assert;

import integration.initialization.testObj.InitializationTestModule;

/**
 * COMMENT
 * @author
 */
public class ModuleInitializationTests {

	private var module:InitializationTestModule;

	[Before]
	public function runBeforeEveryTest():void {
		if (module) {
			module.disposeModule();
		}
	}

	[After]
	public function runAfterEveryTest():void {
		if (module) {
			module.disposeModule();
		}
	}

	[Test]

	public function initializationFunctions_permisionMap_ok():void {
		InitializationTestModule.testType = InitializationTestModule.PERMISION_TEST;
		module = new InitializationTestModule();
	}

	[Test]

	public function initializationFunctions_commandMap_ok():void {
		InitializationTestModule.testType = InitializationTestModule.CONTROLLER_TEST;
		module = new InitializationTestModule();
		Assert.assertTrue("Command should be mappen in initializing function.", module.checkCommandMap());

	}

	[Test]

	public function initializationFunctions_proxyMap_ok():void {
		InitializationTestModule.testType = InitializationTestModule.PROXY_TEST;
		module = new InitializationTestModule();
		Assert.assertTrue("Proxy should be mappen in initializing function.", module.checkProxyMap());
	}

	[Test]

	public function initializationFunctions_mediatorMap_ok():void {
		InitializationTestModule.testType = InitializationTestModule.MEDIATOR_TEST;
		module = new InitializationTestModule();
		Assert.assertTrue("Mediator should be mappen in initializing function.", module.checkMediatorMap());
	}

}
}