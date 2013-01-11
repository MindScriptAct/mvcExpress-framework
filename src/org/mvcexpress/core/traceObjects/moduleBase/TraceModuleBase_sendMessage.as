// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.moduleBase {
import org.mvcexpress.core.ModuleBase;
import org.mvcexpress.core.traceObjects.TraceObj_SendMessage;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceModuleBase_sendMessage extends TraceObj_SendMessage {
	
	public var type:String;
	public var params:Object;
	
	public function TraceModuleBase_sendMessage(action:String, moduleName:String, moduleObject:ModuleBase, type:String, params:Object) {
		super(action, moduleName);
		this.moduleObject = moduleObject;
		this.type = type;
		this.params = params;
		//
		canPrint = false;
	}

}
}