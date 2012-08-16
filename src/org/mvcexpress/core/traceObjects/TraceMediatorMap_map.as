// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMediatorMap_map extends TraceObj {
	
	public var viewClass:Class;
	public var mediatorClass:Class;
	
	public function TraceMediatorMap_map(action:String, moduleName:String, viewClass:Class, mediatorClass:Class) {
		super(action, moduleName);
		this.viewClass = viewClass;
		this.mediatorClass = mediatorClass;
	}
	
	override public function toString():String {
		return "§§§+ " + MvcTraceActions.MEDIATORMAP_MAP + " > viewClass : " + viewClass + ", mediatorClass : " + mediatorClass + "     {" + moduleName + "}";
	}

}
}