// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMessenger_addHandler extends TraceObj {
	
	public var type:String;
	public var handler:Function;
	public var handlerClassName:String;
	
	public function TraceMessenger_addHandler(action:String, moduleName:String, type:String, handler:Function, handlerClassName:String) {
		super(action, moduleName);
		this.type = type;
		this.handler = handler;
		this.handlerClassName = handlerClassName;
	}
	
	override public function toString():String {
		return "••<+ " + MvcTraceActions.MESSENGER_ADDHANDLER + " > type : " + type + ", handlerClassName : " + handlerClassName + "     {" + moduleName + "}";
	}
}
}