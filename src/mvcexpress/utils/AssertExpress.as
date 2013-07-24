// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.utils {

/**
 * Class to assert statements for testing. (Similar to FlexUnit)
 * Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class AssertExpress {

	/**
	 * Function to handle assert errors. Handling function must expect will get 2 parameters as String, userMessage and errorMessage.
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
	 * @param    errorMessage    optional error message.
	 */
	public static function equals(actual:Object, expected:Object, errorMessage:String = ""):void {
		if (actual != expected) {
			errorHandler(errorMessage, "expected:<" + expected + "> but was:<" + actual + ">");
		}
	}

	/**
	 * Asserts that the provided values are strictly equal.
	 *
	 * @param    actual            value under test.
	 * @param    expected        expected value.
	 * @param    errorMessage    optional error message.
	 */
	public static function strictlyEquals(actual:Object, expected:Object, errorMessage:String = ""):void {
		if (actual !== expected) {
			errorHandler(errorMessage, "expected:<" + expected + "> but was:<" + actual + ">");
		}
	}

	/**
	 * Asserts that a condition is true.
	 *
	 * @param    condition        value under test.
	 * @param    errorMessage    optional error message.
	 */
	public static function isTrue(condition:Boolean, errorMessage:String = ""):void {
		if (!condition) {
			errorHandler(errorMessage, "expected:<true> but was:<" + condition + ">");
		}
	}

	/**
	 * Asserts that a condition is false.
	 *
	 * @param    condition        value under test.
	 * @param    errorMessage    optional error message.
	 */
	public static function isFalse(condition:Boolean, errorMessage:String = ""):void {
		if (condition) {
			errorHandler(errorMessage, "expected:<false> but was:<" + condition + ">");
		}
	}

	/**
	 * Asserts that object is null.
	 *
	 * @param    actual            value under test.
	 * @param    errorMessage    optional error message.
	 */
	public static function isNull(actual:Object, errorMessage:String = ""):void {
		if (actual != null) {
			errorHandler(errorMessage, "expected:<null> but was:<" + actual + ">");
		}
	}

	/**
	 * Asserts that object is not null.
	 *
	 * @param    actual            value under test.
	 * @param    errorMessage    optional error message.
	 */
	public static function isNotNull(actual:Object, errorMessage:String = ""):void {
		if (actual == null) {
			errorHandler(errorMessage, "expected:<not null> but was:<" + actual + ">");
		}
	}

	/**
	 * Fails a test with the argument message.
	 *
	 * @param    errorMessage    optional error message.
	 */
	public static function fail(errorMessage:String = ""):void {
		errorHandler(errorMessage, "failed!");
	}


	//----------------------------------
	//     internals
	//----------------------------------

	private static function throwError(userMessage:String, errorMessage:String):void {
		if (userMessage.length > 0) {
			userMessage = userMessage + " - ";
		}
		throw Error(userMessage + errorMessage);
	}

}
}