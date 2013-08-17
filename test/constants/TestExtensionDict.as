package constants {
import flash.utils.Dictionary;

import mvcexpress.modules.ModuleCore;

public class TestExtensionDict {

	private static var defaultExtensionDict:Dictionary;


	static public function getDefaultExtensionDict():Dictionary {
		if (!defaultExtensionDict) {
			defaultExtensionDict = new Dictionary();
			defaultExtensionDict[ModuleCore.EXTENSION_CORE_ID] = true;
		}
		return defaultExtensionDict;
	}


}
}
