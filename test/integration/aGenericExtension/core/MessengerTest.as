package integration.aGenericExtension.core {
import flash.utils.Dictionary;

import integration.aGenericExtension.module.ModuleTest;

import mvcexpress.core.messenger.Messenger;

public class MessengerTest extends Messenger {

	public function MessengerTest($moduleName:String) {
		super($moduleName);
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
