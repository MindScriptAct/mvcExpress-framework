package integration.moduleInitTests {
import flexunit.framework.Assert;

import integration.moduleInitTests.testObj.InitTestModuleCore;

/**
 * COMMENT
 * @author mindscriptact
 */
public class ModuleInitTests {

	private var module:Object;

	[Before]

	public function runBeforeEveryTest():void {

	}

	[After]

	public function runAfterEveryTest():void {
		if (module) {
			module["disposeModule"]();
		}
	}

	//----------------------------------
	//	moduleCore
	//----------------------------------

	[Test]

	public function moduleInit_coreAutoInit_notNull():void {
		var testModule:InitTestModuleCore = new InitTestModuleCore();
		module = testModule;

		Assert.assertNotNull("ModuleCore proxyMap should be not null after autoInit", testModule.getProxyMap());
		Assert.assertNotNull("ModuleCore commandMap should be not null after autoInit", testModule.getCommandMap());
		Assert.assertNotNull("ModuleCore mediatorMap should be not null after autoInit", testModule.getMediatorMap());
	}

}
}