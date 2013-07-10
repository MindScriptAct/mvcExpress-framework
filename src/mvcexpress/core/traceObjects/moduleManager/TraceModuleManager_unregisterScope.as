// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.moduleManager {
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceModuleManager_unregisterScope extends TraceObj {

	public var scopeName:String;

	public function TraceModuleManager_unregisterScope(moduleName:String, $scopeName:String) {
		super(MvcTraceActions.MODULEMANAGER_UNREGISTERSCOPE, moduleName);
		scopeName = $scopeName;
	}

	override public function toString():String {
		return "##**-- " + MvcTraceActions.MODULEMANAGER_UNREGISTERSCOPE + " > moduleName : " + moduleName + ", scopeName : " + scopeName;
	}

}
}