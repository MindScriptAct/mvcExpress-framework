package org.mvcexpress.core.traceObjects {
import org.mvcexpress.core.inject.InjectRuleVO;

/**
 * COMMENT
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
		return "WARNING: Pending injection. Inject object is not found for class with id:" + rule.injectClassAndName + "(needed in " + hostObject + ")";
	}
}
}