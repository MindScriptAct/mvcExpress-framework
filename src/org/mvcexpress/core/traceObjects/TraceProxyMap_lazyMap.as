// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import flash.display.DisplayObject;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProxyMap_lazyMap extends TraceObj {
	
	public var proxyClass:Class;
	public var injectClass:Class;
	public var name:String;
	public var proxyParams:Array;
	
	public var dependencies:Vector.<Object>;
	
	public var view:DisplayObject;
	
	public function TraceProxyMap_lazyMap(action:String, moduleName:String, proxyClass:Class, injectClass:Class, name:String, proxyParams:Array) {
		super(action, moduleName);
		this.proxyParams = proxyParams;
		this.proxyClass = proxyClass;
		this.injectClass = injectClass;
		this.name = name;
	}
	
	override public function toString():String {
		return "¶¶¶+ " + MvcTraceActions.PROXYMAP_LAZYMAP + " > proxyClass : " + proxyClass + ", injectClass : " + injectClass + ", name : " + name+ ", proxyParams : " + proxyParams + "     {" + moduleName + "}";
	}

}
}