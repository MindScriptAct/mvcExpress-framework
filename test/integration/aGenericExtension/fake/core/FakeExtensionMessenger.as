package integration.aGenericExtension.fake.core {
import flash.utils.Dictionary;

import integration.aGenericExtension.fake.module.FakeExtensionModule;

import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

use namespace pureLegsCore;

public class FakeExtensionMessenger extends Messenger {

	public function FakeExtensionMessenger($moduleName:String) {
		super($moduleName);
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	override pureLegsCore function setSupportedExtensions(supportedExtensions:Dictionary):void {
		super.setSupportedExtensions(supportedExtensions);
		if (!SUPPORTED_EXTENSIONS[FakeExtensionModule.pureLegsCore::EXTENSION_TEST_ID]) {
			throw Error("This extension is not supported by current module. You need " + FakeExtensionModule.pureLegsCore::EXTENSION_TEST_NAME + " extension enabled.");
		}
	}
}
}
