package constants {
import flash.utils.Dictionary;

import mvcexpress.core.namespace.pureLegsCore;

import mvcexpress.modules.ModuleCore;

use namespace pureLegsCore;

public class TestExtensionDict {

	private static var defaultExtensionDict:Dictionary;


	static public function getDefaultExtensionDict():Dictionary {
		if (!defaultExtensionDict) {
			defaultExtensionDict = new Dictionary();
			CONFIG::debug {
				defaultExtensionDict[ModuleCore.pureLegsCore::EXTENSION_CORE_ID] = true;
			}
		}
		return defaultExtensionDict;
	}


}
}
