// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import flash.display.DisplayObject;

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
		return "¶¶¶¶- " + MvcTraceActions.COMMANDMAP_UNMAP + " > injectClass : " + injectClass + ", name : " + name + "     {" + moduleName + "}";
	}

}
}