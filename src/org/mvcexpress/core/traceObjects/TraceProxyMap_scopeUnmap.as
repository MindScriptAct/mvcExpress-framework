// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import flash.display.DisplayObject;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProxyMap_scopeUnmap extends TraceObj {
	
	public var scopeName:String;
	public var injectClass:Class;
	public var name:String;
	
	public var dependencies:Vector.<Object>;
	
	public var view:DisplayObject;
	
	public function TraceProxyMap_scopeUnmap(action:String, moduleName:String, scopeName:String, injectClass:Class, name:String) {
		super(action, moduleName);
		this.scopeName = scopeName;
		this.injectClass = injectClass;
		this.name = name;
	}
	
	override public function toString():String {
		return "{$}¶¶¶¶- " + MvcTraceActions.PROXYMAP_SCOPEUNMAP + " > scopeName : " + scopeName + ", injectClass : " + injectClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}