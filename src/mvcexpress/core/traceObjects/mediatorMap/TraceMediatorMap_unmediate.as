// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.mediatorMap {
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.mvc.Mediator;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceMediatorMap_unmediate extends TraceObj {
	public var viewObject:Object;
	public var mediatorObject:Mediator;
	public var viewClass:Class;
	public var mediatorClass:Class;
	public var mediatorClassName:String;

	public function TraceMediatorMap_unmediate(moduleName:String, $viewObject:Object) {
		super(MvcTraceActions.MEDIATORMAP_UNMEDIATE, moduleName);
		viewObject = $viewObject;
	}

	override public function toString():String {
		return "§*- " + MvcTraceActions.MEDIATORMAP_UNMEDIATE + " > viewObject : " + viewObject + "     {" + moduleName + "}";
	}

}
}