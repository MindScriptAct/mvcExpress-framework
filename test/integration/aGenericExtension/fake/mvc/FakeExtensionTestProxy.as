package integration.aGenericExtension.fake.mvc {
import integration.aGenericExtension.fake.module.FakeExtensionModule;

import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.mvc.Proxy;

use namespace pureLegsCore;

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

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = FakeExtensionModule.pureLegsCore::EXTENSION_TEST_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = FakeExtensionModule.pureLegsCore::EXTENSION_TEST_NAME

}
}