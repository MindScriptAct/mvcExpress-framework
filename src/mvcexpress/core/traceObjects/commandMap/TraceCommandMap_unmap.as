// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.commandMap {
import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceCommandMap_unmap extends TraceObj {

	public var type:String;
	public var commandClass:Class;

	public function TraceCommandMap_unmap(moduleName:String, $type:String, $commandClass:Class) {
		super(MvcTraceActions.COMMANDMAP_UNMAP, moduleName);
		type = $type;
		commandClass = $commandClass;
	}

	override public function toString():String {
		return "©©©- " + MvcTraceActions.COMMANDMAP_UNMAP + " > type : " + type + ", commandClass : " + commandClass + "     {" + moduleName + "}";
	}

}
}