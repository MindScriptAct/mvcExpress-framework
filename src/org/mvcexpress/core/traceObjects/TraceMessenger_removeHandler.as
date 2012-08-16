// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMessenger_removeHandler extends TraceObj {
	
	public var type:String;
	public var handler:Function;
	
	public function TraceMessenger_removeHandler(action:String, moduleName:String, type:String, handler:Function) {
		super(action, moduleName);
		this.type = type;
		this.handler = handler;
	}
	
	override public function toString():String {
		return "••<- " + MvcTraceActions.MESSENGER_REMOVEHANDLER + " > type : " + type + "     {" + moduleName + "}";
	}
}
}