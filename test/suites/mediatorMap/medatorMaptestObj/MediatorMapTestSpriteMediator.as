package suites.mediatorMap.medatorMaptestObj {
import mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MediatorMapTestSpriteMediator extends Mediator {

	static public var TEST_MESSAGE_TYPE:String = "mediatorMapTestType";

	static public var REGISTER_TEST_FUNCTION:Function = function (msg:* = null):void {
	};
	static public var REMOVE_TEST_FUNCTION:Function = function (msg:* = null):void {
	};
	static public var CALLBACK_TEST_FUNCTION:Function = function (msg:* = null):void {
	};

	override public function onRegister():void {
		MediatorMapTestSpriteMediator.REGISTER_TEST_FUNCTION();

		addHandler(MediatorMapTestSpriteMediator.TEST_MESSAGE_TYPE, handleTestCallBack);
	}

	override public function onRemove():void {
		MediatorMapTestSpriteMediator.REMOVE_TEST_FUNCTION();
	}

	private function handleTestCallBack(params:Object):void {
		MediatorMapTestSpriteMediator.CALLBACK_TEST_FUNCTION();
	}

}
}