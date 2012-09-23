// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import flash.display.DisplayObject;
import org.mvcexpress.mvc.Command;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceCommand_sendScopeMessage extends TraceObj_SendMessage {
	
	public var type:String;
	public var params:Object;
	
	public function TraceCommand_sendScopeMessage(action:String, moduleName:String, commandObject:Command, type:String, params:Object) {
		super(action, moduleName);
		this.commandObject = commandObject;
		this.type = type;
		this.params = params;
		//
		canPrint = false;
	}

}
}