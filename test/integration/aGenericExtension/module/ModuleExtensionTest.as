package integration.aGenericExtension.module {
import mvcexpress.core.ModuleManager;
import mvcexpress.modules.ModuleCore;

public class ModuleExtensionTest extends ModuleCore {

	public function ModuleExtensionTest(moduleName:String = null, extendedMediatorMapClass:Class = null, extendedProxyMapClass:Class = null, extendedCommandMapClass:Class = null, extendedMessengerClass:Class = null) {

		CONFIG::debug {
			enableExtension(EXTENSION_TEST_ID);
		}

		super(moduleName, extendedMediatorMapClass, extendedProxyMapClass, extendedCommandMapClass, extendedMessengerClass);
	}



	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static public const EXTENSION_TEST_ID:int = ModuleManager.getExtensionId(EXTENSION_TEST_NAME);

	CONFIG::debug
	static public const EXTENSION_TEST_NAME:String = "test_module";
}
}
