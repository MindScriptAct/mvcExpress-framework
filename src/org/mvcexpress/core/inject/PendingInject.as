// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.inject {
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

/**
 * FOR INTERNAL USE ONLY.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class PendingInject {
	
	/**
	 * Private class to store pending injection data.
	 * @private
	 */
	
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