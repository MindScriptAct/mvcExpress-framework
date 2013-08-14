package integration.aGenericExtension.core {
import flash.utils.Dictionary;

import integration.aGenericExtension.module.ModuleTest;

import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;

public class MediatorMapTest extends MediatorMap {
	public function MediatorMapTest($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap) {
		super($moduleName, $messenger, $proxyMap);
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	override public function setSupportedExtensions(supportedExtensions:Dictionary):void {
		super.setSupportedExtensions(supportedExtensions);
		if (!SUPPORTED_EXTENSIONS[ModuleTest.EXTENSION_TEST_ID]) {
			throw Error("This extension is not supported by current module. You need " + ModuleTest.EXTENSION_TEST_NAME + " extension enabled.");
		}
	}
}
}
