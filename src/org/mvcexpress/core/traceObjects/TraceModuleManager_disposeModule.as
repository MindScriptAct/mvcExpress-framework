// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceModuleManager_disposeModule extends TraceObj {
	
	public function TraceModuleManager_disposeModule(action:String, moduleName:String) {
		super(action, moduleName);
	}
	
	override public function toString():String {
		return "#####- " + MvcTraceActions.MODULEMANAGER_DISPOSEMODULE + " > moduleName : " + moduleName;
	}

}
}