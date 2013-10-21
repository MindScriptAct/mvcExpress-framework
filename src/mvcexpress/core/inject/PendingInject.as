// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.inject {
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

/**
 * FOR INTERNAL USE ONLY.
 * Private class to store pending injection data.
 * @private
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class PendingInject {

	private var injectClassAndName:String;
	public var pendingObject:Object;
	public var signatureClass:Class;
	private var pendingInjectTime:int;

	private var timerId:uint;

	public function PendingInject($injectClassAndName:String, $pendingObject:Object, $signatureClass:Class, $pendingInjectTime:int) {
		injectClassAndName = $injectClassAndName;
		pendingObject = $pendingObject;
		signatureClass = $signatureClass;
		pendingInjectTime = $pendingInjectTime;
		// start timer to throw an error of unresolved injection.
		timerId = setTimeout(throwError, $pendingInjectTime);
	}

	public function stopTimer():void {
		clearTimeout(timerId);
	}

	private function throwError():void {
		throw Error("Pending inject object is not resolved in " + (pendingInjectTime / 1000) + " second for class with id:" + injectClassAndName + "(needed in " + pendingObject + ")");
	}

}
}