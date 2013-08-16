package integration.aGenericExtension.mvc {
import integration.aGenericExtension.module.ModuleExtensionTest;

import mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class CommnadExstensionTest extends Command {

	public function execute(blank:Object):void {

	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static public var extension_id:int = ModuleExtensionTest.EXTENSION_TEST_ID;

	CONFIG::debug
	static public var extension_name:String = ModuleExtensionTest.EXTENSION_TEST_NAME

}
}
