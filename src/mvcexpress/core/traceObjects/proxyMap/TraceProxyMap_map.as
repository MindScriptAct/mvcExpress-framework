// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.proxyMap {
import flash.display.DisplayObject;

import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.mvc.Proxy;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceProxyMap_map extends TraceObj {

	public var proxyObject:Proxy;
	public var injectClass:Class;
	public var name:String;

	public var dependencies:Vector.<Object>;

	public var view:DisplayObject;

	public function TraceProxyMap_map(moduleName:String, $proxyObject:Proxy, $injectClass:Class, $name:String) {
		super(MvcTraceActions.PROXYMAP_MAP, moduleName);
		proxyObject = $proxyObject;
		injectClass = $injectClass;
		name = $name;
	}

	override public function toString():String {
		return "¶¶¶+ " + MvcTraceActions.PROXYMAP_MAP + " > proxyObject : " + proxyObject + ", injectClass : " + injectClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}