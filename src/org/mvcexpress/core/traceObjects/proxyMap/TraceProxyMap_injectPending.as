// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.proxyMap {
import org.mvcexpress.core.inject.InjectRuleVO;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProxyMap_injectPending extends TraceObj {
	
	public var hostObject:Object;
	public var injectObject:Object;
	public var rule:InjectRuleVO;
	
	public function TraceProxyMap_injectPending(action:String, moduleName:String, hostObject:Object, injectObject:Object, rule:InjectRuleVO) {
		super(action, moduleName);
		this.hostObject = hostObject;
		this.injectObject = injectObject;
		this.rule = rule;
	
	}
	
	override public function toString():String {
		return "!!!!! " + MvcTraceActions.PROXYMAP_INJECTPENDING + " > for id:" + rule.injectClassAndName + "(needed in " + hostObject + ")" + "     {" + moduleName + "}";
	}
}
}