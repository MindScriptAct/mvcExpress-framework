// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.moduleManager {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceModuleManager_disposeModule extends TraceObj {
	
	public function TraceModuleManager_disposeModule(moduleName:String) {
		super(MvcTraceActions.MODULEMANAGER_DISPOSEMODULE, moduleName);
	}
	
	override public function toString():String {
		return "#####- " + MvcTraceActions.MODULEMANAGER_DISPOSEMODULE + " > moduleName : " + moduleName;
	}

}
}