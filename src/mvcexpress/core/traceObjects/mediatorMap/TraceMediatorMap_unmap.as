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
public class TraceMediatorMap_unmap extends TraceObj {

	public var viewClass:Class;
	public var mediatorClass:Class;

	public function TraceMediatorMap_unmap(moduleName:String, $viewClass:Class, $mediatorClass:Class) {
		super(MvcTraceActions.MEDIATORMAP_UNMAP, moduleName);
		viewClass = $viewClass;
		mediatorClass = $mediatorClass;
	}

	override public function toString():String {
		if (mediatorClass) {
			return "§§§- " + MvcTraceActions.MEDIATORMAP_UNMAP + " > viewClass : " + viewClass + " from " + mediatorClass + "      {" + moduleName + "}";
		} else {
			return "§§§- " + MvcTraceActions.MEDIATORMAP_UNMAP + " > viewClass : " + viewClass + " from ALL mediators.          {" + moduleName + "}";

		}
	}

}
}