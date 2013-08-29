package integration.aGenericExtension.fake.core {
import flash.utils.Dictionary;

import integration.aGenericExtension.fake.module.FakeExtensionModule;

import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;

public class FakeExtensionProxyMap extends ProxyMap {
	public function FakeExtensionProxyMap($moduleName:String, $messenger:Messenger) {
		super($moduleName, $messenger);
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	override public function setSupportedExtensions(supportedExtensions:Dictionary):void {
		super.setSupportedExtensions(supportedExtensions);
		if (!SUPPORTED_EXTENSIONS[FakeExtensionModule.EXTENSION_TEST_ID]) {
			throw Error("This extension is not supported by current module. You need " + FakeExtensionModule.EXTENSION_TEST_NAME + " extension enabled.");
		}
	}
}
}
