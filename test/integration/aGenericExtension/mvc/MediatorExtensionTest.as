package integration.aGenericExtension.mvc {
import flash.display.Sprite;

import integration.aGenericExtension.module.ModuleExtensionTest;

import integration.aGenericExtension.module.ModuleExtensionTest;

import mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class MediatorExtensionTest extends Mediator {

	[Inject]
	public var view:Sprite;

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