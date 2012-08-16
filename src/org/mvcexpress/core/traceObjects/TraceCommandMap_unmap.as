// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceCommandMap_unmap extends TraceObj {
	
	public var type:String;
	public var commandClass:Class;
	
	public function TraceCommandMap_unmap(action:String, moduleName:String, type:String, commandClass:Class) {
		super(action, moduleName);
		this.type = type;
		this.commandClass = commandClass;
	}
	
	override public function toString():String {
		return "©©©- " + MvcTraceActions.COMMANDMAP_UNMAP + " > type : " + type + ", commandClass : " + commandClass + "     {" + moduleName + "}";
	}

}
}