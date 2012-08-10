package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMessenger_send extends TraceObj {
	
	public var type:String;
	public var params:Object;
	
	public function TraceMessenger_send(action:String, moduleName:String, type:String, params:Object) {
		super(action, moduleName);
		this.type = type;
		this.params = params;
	}
	
	override public function toString():String {
		return "•> Messenger.send > type : " + type + ", params : " + params;
	}
}
}