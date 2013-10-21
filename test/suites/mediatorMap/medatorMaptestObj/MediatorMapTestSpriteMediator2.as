package suites.mediatorMap.medatorMaptestObj {
import flash.display.Sprite;

import mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class MediatorMapTestSpriteMediator2 extends Mediator {

	[Inject]
	public var view:Sprite;

	static public var TEST_MESSAGE_TYPE2:String = "mediatorMapTestType";

	static public var REGISTER_TEST_FUNCTION2:Function = function (msg:* = null):void {
	};
	static public var REMOVE_TEST_FUNCTION2:Function = function (msg:* = null):void {
	};
	static public var CALLBACK_TEST_FUNCTION2:Function = function (msg:* = null):void {
	};

	override protected function onRegister():void {
		MediatorMapTestSpriteMediator2.REGISTER_TEST_FUNCTION2();

		addHandler(MediatorMapTestSpriteMediator2.TEST_MESSAGE_TYPE2, handleTestCallBack);
	}

	override protected function onRemove():void {
		MediatorMapTestSpriteMediator2.REMOVE_TEST_FUNCTION2();
	}

	private function handleTestCallBack(params:Object):void {
		MediatorMapTestSpriteMediator2.CALLBACK_TEST_FUNCTION2();
	}

}
}