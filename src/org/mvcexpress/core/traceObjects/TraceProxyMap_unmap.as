package org.mvcexpress.core.traceObjects {
import flash.display.DisplayObject;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProxyMap_unmap extends TraceObj {
	
	public var injectClass:Class;
	public var name:String;
	
	public var dependencies:Vector.<Object>;
	
	public var view:DisplayObject;
	
	public function TraceProxyMap_unmap(action:String, moduleName:String, injectClass:Class, name:String) {
		super(action, moduleName);
		this.injectClass = injectClass;
		this.name = name;
	}
	
	override public function toString():String {
		return "¶¶¶¶- ProxyMap.unmap > injectClass : " + injectClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}