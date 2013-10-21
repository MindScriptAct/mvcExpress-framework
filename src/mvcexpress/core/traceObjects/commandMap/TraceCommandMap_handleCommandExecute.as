// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects.commandMap {
import flash.display.DisplayObject;

import mvcexpress.core.traceObjects.MvcTraceActions;
import mvcexpress.core.traceObjects.TraceObj;
import mvcexpress.modules.ModuleCore;
import mvcexpress.mvc.Command;
import mvcexpress.mvc.Mediator;
import mvcexpress.mvc.Proxy;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class TraceCommandMap_handleCommandExecute extends TraceObj {

	public var commandObject:Command;
	public var commandClass:Class;
	public var type:String;
	public var params:Object;

	public var view:DisplayObject;

	public var messageFromModule:ModuleCore;
	public var messageFromMediator:Mediator;
	public var messageFromProxy:Proxy;
	public var messageFromCommand:Command;

	public function TraceCommandMap_handleCommandExecute(moduleName:String, $commandObject:Command, $commandClass:Class, $type:String, $params:Object) {
		super(MvcTraceActions.COMMANDMAP_HANDLECOMMANDEXECUTE, moduleName);
		commandObject = $commandObject;
		commandClass = $commandClass;
		type = $type;
		params = $params;
	}

	override public function toString():String {
		return "©* " + MvcTraceActions.COMMANDMAP_HANDLECOMMANDEXECUTE + " > messageType : " + type + ", params : " + params + " Executed with : " + commandClass + "{" + moduleName + "}";
	}

}
}