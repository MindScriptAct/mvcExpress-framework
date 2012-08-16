// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import flash.display.DisplayObject;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProxyMap_map extends TraceObj {
	
	public var proxyObject:Proxy;
	public var injectClass:Class;
	public var name:String;
	
	public var dependencies:Vector.<Object>;
	
	public var view:DisplayObject;
	
	public function TraceProxyMap_map(action:String, moduleName:String, proxyObject:Proxy, injectClass:Class, name:String) {
		super(action, moduleName);
		this.proxyObject = proxyObject;
		this.injectClass = injectClass;
		this.name = name;
	}
	
	override public function toString():String {
		return "¶¶¶+ " + MvcTraceActions.PROXYMAP_MAP + " > proxyObject : " + proxyObject + ", injectClass : " + injectClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}