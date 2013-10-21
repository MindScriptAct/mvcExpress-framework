// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.proxyMap {
import flash.display.DisplayObject;

import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceProxyMap_lazyMap extends TraceObj {

	public var proxyClass:Class;
	public var injectClass:Class;
	public var name:String;
	public var proxyParams:Array;

	public var dependencies:Vector.<Object>;

	public var view:DisplayObject;

	public function TraceProxyMap_lazyMap(moduleName:String, $proxyClass:Class, $injectClass:Class, $name:String, $proxyParams:Array) {
		super(MvcTraceActions.PROXYMAP_LAZYMAP, moduleName);
		proxyParams = $proxyParams;
		proxyClass = $proxyClass;
		injectClass = $injectClass;
		name = $name;
	}

	override public function toString():String {
		return "¶¶¶+ " + MvcTraceActions.PROXYMAP_LAZYMAP + " > proxyClass : " + proxyClass + ", injectClass : " + injectClass + ", name : " + name + ", proxyParams : " + proxyParams + "     {" + moduleName + "}";
	}

}
}