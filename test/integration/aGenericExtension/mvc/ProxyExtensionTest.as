package integration.aGenericExtension.mvc {
import integration.aGenericExtension.module.ModuleExtensionTest;

import mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class ProxyExtensionTest extends Proxy {

	public function ProxyExtensionTest() {
	}

	override protected function onRegister():void {

	}

	override protected function onRemove():void {
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