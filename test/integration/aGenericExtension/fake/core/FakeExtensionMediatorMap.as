package integration.aGenericExtension.fake.core {
import flash.utils.Dictionary;

import integration.aGenericExtension.fake.module.FakeExtensionModule;

import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

use namespace pureLegsCore;

public class FakeExtensionMediatorMap extends MediatorMap {
	public function FakeExtensionMediatorMap($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap) {
		super($moduleName, $messenger, $proxyMap);
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------


	CONFIG::debug
	override pureLegsCore function setSupportedExtensions(supportedExtensions:Dictionary):void {
		use namespace pureLegsCore;
		super.setSupportedExtensions(supportedExtensions);
		if (!SUPPORTED_EXTENSIONS[FakeExtensionModule.EXTENSION_TEST_ID]) {
			throw Error("This extension is not supported by current module. You need " + FakeExtensionModule.EXTENSION_TEST_NAME + " extension enabled.");
		}
	}
}
}
