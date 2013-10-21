// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.utils {

/**
 * Class to assert statements for testing. (Similar to FlexUnit)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class AssertExpress {

	/**
	 * Function to handle assert errors. Handling function must expect will get 2 parameters as String, customMessage and errorMessage.
	 * By default it set to function that throws Error's.
	 */
	public static var errorHandler:Function = throwError;


	//----------------------------------
	//     asserts
	//----------------------------------

	/**
	 *  Asserts that two provided values are equal.
	 *
	 * @param    actual          value under test.
	 * @param    expected        expected value.
	 * @param    customMessage    optional error message.
	 */
	public static function equals(actual:Object, expected:Object, customMessage:String = ""):void {
		if (actual != expected) {
			errorHandler(customMessage, "expected:<" + expected + "> but was:<" + actual + ">");
		}
	}

	/**
	 * Asserts that the provided values are strictly equal.
	 *
	 * @param    actual            value under test.
	 * @param    expected        expected value.
	 * @param    customMessage    optional error message.
	 */
	public static function strictlyEquals(actual:Object, expected:Object, customMessage:String = ""):void {
		if (actual !== expected) {
			errorHandler(customMessage, "expected:<" + expected + "> but was:<" + actual + ">");
		}
	}

	/**
	 * Asserts that a condition is true.
	 *
	 * @param    condition        value under test.
	 * @param    customMessage    optional error message.
	 */
	public static function isTrue(condition:Boolean, customMessage:String = ""):void {
		if (!condition) {
			errorHandler(customMessage, "expected:<true> but was:<" + condition + ">");
		}
	}

	/**
	 * Asserts that a condition is false.
	 *
	 * @param    condition        value under test.
	 * @param    customMessage    optional error message.
	 */
	public static function isFalse(condition:Boolean, customMessage:String = ""):void {
		if (condition) {
			errorHandler(customMessage, "expected:<false> but was:<" + condition + ">");
		}
	}

	/**
	 * Asserts that object is null.
	 *
	 * @param    actual            value under test.
	 * @param    customMessage    optional error message.
	 */
	public static function isNull(actual:Object, customMessage:String = ""):void {
		if (actual != null) {
			errorHandler(customMessage, "expected:<null> but was:<" + actual + ">");
		}
	}

	/**
	 * Asserts that object is not null.
	 *
	 * @param    actual            value under test.
	 * @param    customMessage    optional error message.
	 */
	public static function isNotNull(actual:Object, customMessage:String = ""):void {
		if (actual == null) {
			errorHandler(customMessage, "expected:<not null> but was:<" + actual + ">");
		}
	}

	/**
	 * Fails a test with the argument message.
	 *
	 * @param    customMessage    optional error message.
	 */
	public static function fail(customMessage:String = ""):void {
		errorHandler(customMessage, "failed!");
	}


	//----------------------------------
	//     internals
	//----------------------------------

	private static function throwError(userMessage:String, customMessage:String):void {
		if (userMessage.length > 0) {
			userMessage = userMessage + " - ";
		}
		throw Error(userMessage + customMessage);
	}

}
}