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
		return "#####+ ModuleManager.createModule > moduleName : " + moduleName + ", autoInit : " + autoInit;
	}

}
}