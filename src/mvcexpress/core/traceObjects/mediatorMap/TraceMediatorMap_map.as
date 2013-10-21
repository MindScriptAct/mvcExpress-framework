// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.mediatorMap {
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceMediatorMap_map extends TraceObj {

	public var viewClass:Class;
	public var mediatorClass:Class;
	public var injectClass:Class;

	public function TraceMediatorMap_map(moduleName:String, $viewClass:Class, $mediatorClass:Class, $injectClass:Class) {
		super(MvcTraceActions.MEDIATORMAP_MAP, moduleName);
		viewClass = $viewClass;
		mediatorClass = $mediatorClass;
		injectClass = $injectClass;
	}

	override public function toString():String {
		if (injectClass) {
			return "§§§+ " + MvcTraceActions.MEDIATORMAP_MAP + " > viewClass : " + viewClass + "(as " + injectClass + "), mediatorClass : " + mediatorClass + "     {" + moduleName + "}";
		} else {
			return "§§§+ " + MvcTraceActions.MEDIATORMAP_MAP + " > viewClass : " + viewClass + ", mediatorClass : " + mediatorClass + "     {" + moduleName + "}";
		}
	}

}
}