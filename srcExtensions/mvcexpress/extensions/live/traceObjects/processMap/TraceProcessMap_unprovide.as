// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.traceObjects.processMap {
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.extensions.live.traceObjects.MvcTraceActionsLive;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version live.1.0.beta2
 */
public class TraceProcessMap_unprovide extends TraceObj {

	public var name:String;
	public var object:Object;

	public function TraceProcessMap_unprovide(action:String, moduleName:String, $name:String, $object:Object) {
		super(action, moduleName);
		name = $name;
		object = $object;
	}

	override public function toString():String {
		return "ÆÆ-- " + MvcTraceActionsLive.PROCESSMAP_UNPROVIDE + " > name : " + name + ", object : " + object + "     {" + moduleName + "}";
	}

}
}