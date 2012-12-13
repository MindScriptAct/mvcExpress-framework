package org.mvcexpress.utils {

/**
 * COMMENT
 * @author rBanevicius
 */
public class ExpressAssert {
	
	static private var instance:ExpressAssert;
	
	static public function getInstance():ExpressAssert {
		if (!ExpressAssert.instance) {
			ExpressAssert.instance = new ExpressAssert();
		}
		return ExpressAssert.instance;
	}
	
	public function ExpressAssert() {
		if (ExpressAssert.instance) {
			throw Error("Singleton class, use getInstance().");
		}
	}
	
	//----------------------------------
	//     asserts
	//----------------------------------
	
	/**
	 *  Asserts that two provided values are equal.
	 *
	 * @param	actual			value under test.
	 * @param	expected		expected value.
	 * @param	errorMessage	optional error message.
	 */
	public function equals(actual:Object, expected:Object, errorMessage:String = ""):void {
		if (actual != expected) {
			throwError(errorMessage, "expected:<" + expected + "> but was:<" + actual + ">");
		}
	}
	
	/**
	 * Asserts that the provided values are strictly equal.
	 *
	 * @param	actual			value under test.
	 * @param	expected		expected value.
	 * @param	errorMessage	optional error message.
	 */
	public function strictlyEquals(actual:Object, expected:Object, errorMessage:String = ""):void {
		if (actual !== expected) {
			throwError(errorMessage, "expected:<" + expected + "> but was:<" + actual + ">");
		}
	}
	
	/**
	 * Asserts that a condition is true.
	 *
	 * @param	condition		value under test.
	 * @param	errorMessage	optional error message.
	 */
	public function isTrue(condition:Boolean, errorMessage:String = ""):void {
		if (!condition) {
			throwError(errorMessage, "expected:<true> but was:<" + condition + ">");
		}
	}
	
	/**
	 * Asserts that a condition is false.
	 *
	 * @param	condition		value under test.
	 * @param	errorMessage	optional error message.
	 */
	public function isFalse(condition:Boolean, errorMessage:String = ""):void {
		if (condition) {
			throwError(errorMessage, "expected:<false> but was:<" + condition + ">");
		}
	}
	
	/**
	 * Asserts that object is null.
	 *
	 * @param	actual			value under test.
	 * @param	errorMessage	optional error message.
	 */
	public function isNull(actual:Object, errorMessage:String = ""):void {
		if (actual != null) {
			throwError(errorMessage, "expected:<null> but was:<" + actual + ">");
		}
	}
	
	/**
	 * Asserts that object is not null.
	 *
	 * @param	actual			value under test.
	 * @param	errorMessage	optional error message.
	 */
	public function isNotNull(actual:Object, errorMessage:String = ""):void {
		if (actual == null) {
			throwError(errorMessage, "expected:<not null> but was:<" + actual + ">");
		}
	}
	
	/**
	 * Fails a test with the argument message.
	 *
	 * @param	errorMessage	optional error message.
	 */
	public static function fail(errorMessage:String = ""):void {
		throwError(errorMessage, "failed!");
	}
	
	//----------------------------------
	//     internals
	//----------------------------------
	
	private static function throwError(userMessage:String, throwError:String):void {
		if (userMessage.length > 0) {
			userMessage = userMessage + " - ";
		}
		throw Error(userMessage + throwError);
	}

}
}