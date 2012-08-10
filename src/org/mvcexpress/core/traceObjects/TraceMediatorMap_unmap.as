package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMediatorMap_unmap extends TraceObj {
	
	public var viewClass:Class;
	
	public function TraceMediatorMap_unmap(action:String, moduleName:String, viewClass:Class) {
		super(action, moduleName);
		this.viewClass = viewClass;
	}
	
	override public function toString():String {
		return "§§§- MediatorMap.unmap > viewClass : " + viewClass + "     {" + moduleName + "}";
	}

}
}