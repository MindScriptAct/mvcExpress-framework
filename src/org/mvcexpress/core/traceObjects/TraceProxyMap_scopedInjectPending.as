// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import org.mvcexpress.core.inject.InjectRuleVO;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceProxyMap_scopedInjectPending extends TraceObj {
	
	public var scopeName:String;
	public var hostObject:Object;
	public var injectObject:Object;
	public var rule:InjectRuleVO;
	
	public function TraceProxyMap_scopedInjectPending(action:String, scopeName:String, moduleName:String, hostObject:Object, injectObject:Object, rule:InjectRuleVO) {
		super(action, moduleName);
		this.scopeName = scopeName;
		this.hostObject = hostObject;
		this.injectObject = injectObject;
		this.rule = rule;
	
	}
	
	override public function toString():String {
		return "!!!!! " + MvcTraceActions.PROXYMAP_INJECTPENDING + " > for scopeName:" + scopeName + " with id:" + rule.injectClassAndName + "(needed in " + hostObject + ")" + "     {" + moduleName + "}";
	}
}
}