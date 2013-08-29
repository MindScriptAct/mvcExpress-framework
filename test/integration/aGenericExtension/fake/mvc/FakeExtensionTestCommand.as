package integration.aGenericExtension.fake.mvc {
import integration.aGenericExtension.fake.module.FakeExtensionModule;

import mvcexpress.mvc.Command;

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
	static public var extension_id:int = FakeExtensionModule.EXTENSION_TEST_ID;

	CONFIG::debug
	static public var extension_name:String = FakeExtensionModule.EXTENSION_TEST_NAME

}
}
