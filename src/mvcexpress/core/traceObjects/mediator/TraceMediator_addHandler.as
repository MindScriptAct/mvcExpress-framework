// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.mediator {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.mvc.Mediator;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceMediator_addHandler extends TraceObj {

	public var type:String;
	public var handler:Function;
	public var mediatorObject:Mediator;

	public function TraceMediator_addHandler(moduleName:String, $mediatorObject:Mediator, $type:String, $handler:Function) {
		use namespace pureLegsCore;

		super(MvcTraceActions.MEDIATOR_ADDHANDLER, moduleName);
		mediatorObject = $mediatorObject;
		type = $type;
		handler = $handler;
		//
		canPrint = false;
	}

}
}