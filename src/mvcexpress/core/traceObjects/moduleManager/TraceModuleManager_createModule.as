// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.moduleManager {
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceModuleManager_createModule extends TraceObj {

	public function TraceModuleManager_createModule(moduleName:String) {
		super(MvcTraceActions.MODULEMANAGER_CREATEMODULE, moduleName);
	}

	override public function toString():String {
		return "#####+ " + MvcTraceActions.MODULEMANAGER_CREATEMODULE + " > moduleName : " + moduleName;
	}

}
}