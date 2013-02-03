// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.moduleManager {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceModuleManager_createModule extends TraceObj {
	
	public var autoInit:Boolean;
	
	public function TraceModuleManager_createModule(moduleName:String, $autoInit:Boolean) {
		super(MvcTraceActions.MODULEMANAGER_CREATEMODULE, moduleName);
		autoInit = $autoInit;
	}
	
	override public function toString():String {
		return "#####+ " + MvcTraceActions.MODULEMANAGER_CREATEMODULE + " > moduleName : " + moduleName + ", autoInit : " + autoInit;
	}

}
}