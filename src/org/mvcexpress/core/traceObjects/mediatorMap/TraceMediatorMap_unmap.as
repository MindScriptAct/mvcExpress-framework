// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.mediatorMap {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceMediatorMap_unmap extends TraceObj {
	
	public var viewClass:Class;
	
	public function TraceMediatorMap_unmap(moduleName:String, $viewClass:Class) {
		super(MvcTraceActions.MEDIATORMAP_UNMAP, moduleName);
		viewClass = $viewClass;
	}
	
	override public function toString():String {
		return "§§§- " + MvcTraceActions.MEDIATORMAP_UNMAP + " > viewClass : " + viewClass + "     {" + moduleName + "}";
	}

}
}