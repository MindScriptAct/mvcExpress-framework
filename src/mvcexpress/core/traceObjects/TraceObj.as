// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects {

/**
 * Base of all trace objects.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
dynamic public class TraceObj {

	public var moduleName:String;
	public var action:String;

	// can print debug text.
	public var canPrint:Boolean = true;

	public function TraceObj($action:String, $moduleName:String) {
		action = $action;
		moduleName = $moduleName;
	}

	public function toString():String {
		return "[TraceObj moduleName=" + moduleName + " action=" + action + "]";
	}
}
}