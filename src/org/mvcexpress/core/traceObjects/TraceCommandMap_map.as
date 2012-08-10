package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceCommandMap_map extends TraceObj {
	
	public var type:String;
	public var commandClass:Class;
	
	public function TraceCommandMap_map(action:String, moduleName:String, type:String, commandClass:Class) {
		super(action, moduleName);
		this.type = type;
		this.commandClass = commandClass;
	}
	
	override public function toString():String {
		return "©©©+ CommandMap.map > type : " + type + ", commandClass : " + commandClass;
	}

}
}