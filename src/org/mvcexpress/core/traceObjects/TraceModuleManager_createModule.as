// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceModuleManager_createModule extends TraceObj {
	
	public var autoInit:Boolean;
	
	public function TraceModuleManager_createModule(action:String, moduleName:String, autoInit:Boolean) {
		super(action, moduleName);
		this.autoInit = autoInit;
	}
	
	override public function toString():String {
		return "#####+ " + MvcTraceActions.MODULEMANAGER_CREATEMODULE + " > moduleName : " + moduleName + ", autoInit : " + autoInit;
	}

}
}