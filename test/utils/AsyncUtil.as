package utils {

import flash.events.Event;
import flash.events.EventDispatcher;

import org.flexunit.async.Async;

public class AsyncUtil extends EventDispatcher {

	public static const ASYNC_EVENT:String = "asyncEvent";

	private var _testCase:Object;
	private var _callback:Function;
	private var _passThroughArgs:Array;
	private var _callbackArgs:Array;

	public function AsyncUtil(testCase:Object, callback:Function, passThroughArgs:Array = null) {
		_testCase = testCase;
		_callback = callback;
		_passThroughArgs = passThroughArgs;
	}

	public static function asyncHandler(testCase:Object, callback:Function = null, passThroughArgs:Array = null, timeout:Number = 1500, timeouthandler:Function = null):Function {
		var asyncUtil:AsyncUtil = new AsyncUtil(testCase, callback, passThroughArgs);
		asyncUtil.addEventListener(ASYNC_EVENT, Async.asyncHandler(testCase, asyncUtil.asyncEventHandler, timeout, passThroughArgs, timeouthandler));
		return asyncUtil.asyncCallbackHandler;
	}

	public function asyncEventHandler(ev:Event, flexUnitPassThroughArgs:Object = null):void {
		if (_passThroughArgs) {
			_callbackArgs = _callbackArgs.concat(_passThroughArgs);
		}
		if (_callback != null) {
			_callback.apply(null, _callbackArgs);
		}
	}

	public function asyncCallbackHandler(...args:Array):void {
		_callbackArgs = args;
		dispatchEvent(new Event(ASYNC_EVENT));
	}

}

}