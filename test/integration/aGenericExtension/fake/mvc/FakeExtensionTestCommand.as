package integration.aGenericExtension.fake.mvc {
import integration.aGenericExtension.fake.module.FakeExtensionModule;

import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.mvc.Command;

use namespace pureLegsCore;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class FakeExtensionTestCommand extends Command {

	public function execute(blank:Object):void {

	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static pureLegsCore var extension_id:int = FakeExtensionModule.pureLegsCore::EXTENSION_TEST_ID;

	CONFIG::debug
	static pureLegsCore var extension_name:String = FakeExtensionModule.pureLegsCore::EXTENSION_TEST_NAME

}
}
