package org.mvcexpress.core.traceObjects {

/**
 * Base of all trace objects.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceObj {
	public var moduleName:String;
	public var action:String;
	
	public function TraceObj(action:String, moduleName:String) {
		this.action = action;
		this.moduleName = moduleName;
	}
	
	public function toString():String {
		return "[TraceObj moduleName=" + moduleName + " action=" + action + "]";
	}
}
}