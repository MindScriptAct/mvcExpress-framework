package integration.aGenericExtension.core {
import flash.utils.Dictionary;

import integration.aGenericExtension.module.ModuleExtensionTest;

import mvcexpress.core.messenger.Messenger;

public class MessengerExtensionTest extends Messenger {

	public function MessengerExtensionTest($moduleName:String) {
		super($moduleName);
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	override public function setSupportedExtensions(supportedExtensions:Dictionary):void {
		super.setSupportedExtensions(supportedExtensions);
		if (!SUPPORTED_EXTENSIONS[ModuleExtensionTest.EXTENSION_TEST_ID]) {
			throw Error("This extension is not supported by current module. You need " + ModuleExtensionTest.EXTENSION_TEST_NAME + " extension enabled.");
		}
	}
}
}
