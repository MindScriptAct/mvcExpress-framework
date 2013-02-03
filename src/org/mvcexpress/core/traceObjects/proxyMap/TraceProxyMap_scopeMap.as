// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.proxyMap {
import flash.display.DisplayObject;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;
import org.mvcexpress.mvc.Proxy;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceProxyMap_scopeMap extends TraceObj {
	
	public var scopeName:String;
	public var proxyObject:Proxy;
	public var injectClass:Class;
	public var name:String;
	
	public var dependencies:Vector.<Object>;
	
	public var view:DisplayObject;
	
	public function TraceProxyMap_scopeMap(moduleName:String, $scopeName:String, $proxyObject:Proxy, $injectClass:Class, $name:String) {
		super(MvcTraceActions.PROXYMAP_SCOPEMAP, moduleName);
		scopeName = $scopeName;
		proxyObject = $proxyObject;
		injectClass = $injectClass;
		name = $name;
	}
	
	override public function toString():String {
		return "{$}¶¶¶+ " + MvcTraceActions.PROXYMAP_SCOPEMAP + " > scopeName : " + scopeName + "proxyObject : " + proxyObject + ", injectClass : " + injectClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}