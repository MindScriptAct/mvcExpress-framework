package integration.extensionChecking {
import integration.aGenericExtension.core.CommandMapTest;
import integration.aGenericExtension.core.MediatorMapTest;
import integration.aGenericExtension.core.MessengerTest;
import integration.aGenericExtension.core.ProxyMapTest;
import integration.aGenericExtension.module.ModuleTest;

import mvcexpress.core.ModuleManager;
import mvcexpress.modules.ModuleCore;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTests {

	private var moduleCore:ModuleCore;

	[Before]

	public function runBeforeEveryTest():void {
		if (moduleCore) {
			moduleCore.disposeModule();
		}
	}

	[After]

	public function runAfterEveryTest():void {
		if (moduleCore) {
			moduleCore.disposeModule();
		}
		ModuleManager.disposeAll();
	}

	[Test]

	public function extensionChecking_goodMediatorMap_ok():void {
		moduleCore = new ModuleTest("test", MediatorMapTest);
	}

	[Test]

	public function extensionChecking_goodProxyMap_ok():void {
		moduleCore = new ModuleTest("test", null, ProxyMapTest);
	}

	[Test]

	public function extensionChecking_goodCommandMap_ok():void {
		moduleCore = new ModuleTest("test", null, null, CommandMapTest);
	}

	[Test]

	public function extensionChecking_goodMessanger_ok():void {
		moduleCore = new ModuleTest("test", null, null, null, MessengerTest);
	}


	[Test(expects="Error")]

	public function extensionChecking_badMediatorMap_fails():void {
		moduleCore = new ModuleCore("test", MediatorMapTest);
	}

	[Test(expects="Error")]

	public function extensionChecking_badProxyMap_fails():void {
		moduleCore = new ModuleCore("test", null, ProxyMapTest);
	}

	[Test(expects="Error")]

	public function extensionChecking_badCommandMap_fails():void {
		moduleCore = new ModuleCore("test", null, null, CommandMapTest);
	}

	[Test(expects="Error")]

	public function extensionChecking_badMessanger_fails():void {
		moduleCore = new ModuleCore("test", null, null, null, MessengerTest);
	}

}
}