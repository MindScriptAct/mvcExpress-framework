// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.mediatorMap {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceMediatorMap_map extends TraceObj {
	
	public var viewClass:Class;
	public var mediatorClass:Class;
	
	public function TraceMediatorMap_map(moduleName:String, $viewClass:Class, $mediatorClass:Class) {
		super(MvcTraceActions.MEDIATORMAP_MAP, moduleName);
		viewClass = $viewClass;
		mediatorClass = $mediatorClass;
	}
	
	override public function toString():String {
		return "§§§+ " + MvcTraceActions.MEDIATORMAP_MAP + " > viewClass : " + viewClass + ", mediatorClass : " + mediatorClass + "     {" + moduleName + "}";
	}

}
}