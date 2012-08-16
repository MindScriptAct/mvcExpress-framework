// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMessenger_sendToAll extends TraceObj {
	
	public var type:String;
	public var params:Object;
	
	public function TraceMessenger_sendToAll(action:String, moduleName:String, type:String, params:Object) {
		super(action, moduleName);
		this.type = type;
		this.params = params;
	}
	
	override public function toString():String {
		return "•>>> " + MvcTraceActions.MESSENGER_SENDTOALL + " > type : " + type + ", params : " + params;
	}
}
}