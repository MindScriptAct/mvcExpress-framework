package integration.aGenericExtension.fake.mvc {
import integration.aGenericExtension.fake.module.FakeExtensionModule;

import mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class FakeExtensionTestProxy extends Proxy {

	public function FakeExtensionTestProxy() {
	}

	override protected function onRegister():void {

	}

	override protected function onRemove():void {
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