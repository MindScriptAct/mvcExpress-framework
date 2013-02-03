// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.moduleBase {
import org.mvcexpress.core.ModuleBase;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj_SendMessage;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceModuleBase_sendScopeMessage extends TraceObj_SendMessage {
	
	public var type:String;
	public var params:Object;
	
	public function TraceModuleBase_sendScopeMessage(moduleName:String, $moduleObject:ModuleBase, $type:String, $params:Object, preSend:Boolean) {
		use namespace pureLegsCore;
		super(((preSend) ? MvcTraceActions.MODULEBASE_SENDSCOPEMESSAGE : MvcTraceActions.MODULEBASE_SENDSCOPEMESSAGE_CLEAN), moduleName);
		moduleObject = $moduleObject;
		type = $type;
		params = $params;
		//
		canPrint = false;
	}

}
}