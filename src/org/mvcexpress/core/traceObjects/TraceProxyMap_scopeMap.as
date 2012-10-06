// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import flash.display.DisplayObject;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProxyMap_scopeMap extends TraceObj {
	
	public var scopeName:String;
	public var proxyObject:Proxy;
	public var injectClass:Class;
	public var name:String;
	
	public var dependencies:Vector.<Object>;
	
	public var view:DisplayObject;
	
	public function TraceProxyMap_scopeMap(action:String, moduleName:String, scopeName:String, proxyObject:Proxy, injectClass:Class, name:String) {
		trace("TraceProxyMap_scopeMap.TraceProxyMap_scopeMap > action : " + action + ", moduleName : " + moduleName + ", scopeName : " + scopeName + ", proxyObject : " + proxyObject + ", injectClass : " + injectClass + ", name : " + name);
		super(action, moduleName);
		this.scopeName = scopeName;
		this.proxyObject = proxyObject;
		this.injectClass = injectClass;
		this.name = name;
	}
	
	override public function toString():String {
		return "{$}¶¶¶+ " + MvcTraceActions.PROXYMAP_SCOPEMAP + " > scopeName : " + scopeName + "proxyObject : " + proxyObject + ", injectClass : " + injectClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}