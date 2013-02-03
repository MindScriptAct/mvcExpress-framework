// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.proxyMap {
import org.mvcexpress.core.inject.InjectRuleVO;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceProxyMap_injectStuff extends TraceObj {
	
	public var hostObject:Object;
	public var injectObject:Object;
	public var rule:InjectRuleVO;
	
	public function TraceProxyMap_injectStuff(moduleName:String, $hostObject:Object, $injectObject:Object, $rule:InjectRuleVO) {
		use namespace pureLegsCore;
		super(MvcTraceActions.PROXYMAP_INJECTSTUFF, moduleName);
		hostObject = $hostObject;
		injectObject = $injectObject;
		rule = $rule;
		//
		canPrint = false;
	}

}
}