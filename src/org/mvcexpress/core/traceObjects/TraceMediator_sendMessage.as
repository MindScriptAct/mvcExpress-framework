// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMediator_sendMessage extends TraceObj_SendMessage {
	
	public var type:String;
	public var params:Object;
	
	public function TraceMediator_sendMessage(action:String, moduleName:String, mediatorObject:Mediator, type:String, params:Object) {
		super(action, moduleName);
		this.mediatorObject = mediatorObject;
		this.type = type;
		this.params = params;
		//
		canPrint = false;
	}

}
}