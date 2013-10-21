// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.errors {
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress errors.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceError extends TraceObj {

	public var errorMessage:String;

	public function TraceError(moduleName:String, errorMessage:String) {
		super(MvcTraceActions.ERROR_MESSAGE, moduleName);
		this.errorMessage = errorMessage;
	}

	override public function toString():String {
		return "ERROR: " + errorMessage;
	}

}
}