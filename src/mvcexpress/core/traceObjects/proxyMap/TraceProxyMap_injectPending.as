// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.proxyMap {
import mvcexpress.core.inject.InjectRuleVO;
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceProxyMap_injectPending extends TraceObj {

	public var hostObject:Object;
	public var injectObject:Object;
	public var rule:InjectRuleVO;

	public function TraceProxyMap_injectPending(moduleName:String, $hostObject:Object, $injectObject:Object, $rule:InjectRuleVO) {
		super(MvcTraceActions.PROXYMAP_INJECTPENDING, moduleName);
		hostObject = $hostObject;
		injectObject = $injectObject;
		rule = $rule;
	}

	override public function toString():String {
		return "!!!!! " + MvcTraceActions.PROXYMAP_INJECTPENDING + " > for id:" + rule.injectClassAndName + "(needed in " + hostObject + ")" + "     {" + moduleName + "}";
	}
}
}