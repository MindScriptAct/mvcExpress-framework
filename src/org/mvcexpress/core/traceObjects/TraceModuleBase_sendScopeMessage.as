// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import org.mvcexpress.core.ModuleBase;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceModuleBase_sendScopeMessage extends TraceObj_SendMessage {
	
	public var type:String;
	public var params:Object;
	
	public function TraceModuleBase_sendScopeMessage(action:String, moduleName:String, moduleObject:ModuleBase, type:String, params:Object) {
		super(action, moduleName);
		this.moduleObject = moduleObject;
		this.type = type;
		this.params = params;
		//
		canPrint = false;
	}

}
}