package integration.aGenericExtension.fake.module {
import mvcexpress.core.ExtensionManager;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.modules.ModuleCore;

use namespace pureLegsCore;

public class FakeExtensionModule extends ModuleCore {

	public function FakeExtensionModule(moduleName:String = null, extendedMediatorMapClass:Class = null, extendedProxyMapClass:Class = null, extendedCommandMapClass:Class = null, extendedMessengerClass:Class = null) {

		CONFIG::debug {
			enableExtension(EXTENSION_TEST_ID);
		}

		super(moduleName, extendedMediatorMapClass, extendedProxyMapClass, extendedCommandMapClass, extendedMessengerClass);
	}



	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static pureLegsCore var EXTENSION_TEST_ID:int = ExtensionManager.getExtensionIdByName(pureLegsCore::EXTENSION_TEST_NAME);

	CONFIG::debug
	static pureLegsCore const EXTENSION_TEST_NAME:String = "test_module";
}
}
