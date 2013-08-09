// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.core {
import mvcexpress.core.*;
import mvcexpress.core.messenger.HandlerVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

/**
 * Handles command mappings, and executes them on constants
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */

use namespace pureLegsCore;

public class CommandMapScoped extends CommandMap {

	protected var scopeHandlers:Vector.<HandlerVO> = new Vector.<HandlerVO>();

	/** CONSTRUCTOR */
	public function CommandMapScoped($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap, $mediatorMap:MediatorMap) {
		super($moduleName, $messenger, $proxyMap, $mediatorMap);
	}


	//----------------------------------
	//     set up commands to execute scoped constants
	//----------------------------------

	/**
	 * Maps a class for module to module communication, to be executed then message with provided type and scopeName is sent to scope.            <br>
	 * Only one command can be mapped to single messageType, for single scope. Unless canMapOver set to true - error will be thrown if you attempt to map second command class to same message type.
	 * @param    scopeName            both sending and receiving modules must use same scope to make module to module communication.
	 * @param    type                Message type for command class to react to.
	 * @param    commandClass        Command class that will be executed.
	 * @param    canMapOver          Allows mapping command class over already existing command.
	 */
	public function scopeMap(scopeName:String, type:String, commandClass:Class, canMapOver:Boolean = false):void {
		use namespace pureLegsCore;

		//
		var scopedType:String = scopeName + "_^~_" + type;

		if (classRegistry[scopedType]) {
			if (!canMapOver) {
				throw Error("Only one command class can be mapped to one message type. You are trying to map " + commandClass + " to " + type + " with scope " + scopeName + ", but it is already mapped to " + classRegistry[type]);
			}
		} else {
			scopeHandlers[scopeHandlers.length] = ScopeManager.scopedCommandMap(moduleName, handleCommandExecute, scopeName, type, commandClass)
		}

		classRegistry[scopedType] = commandClass;
	}

	/**
	 * Unmaps a class for module to module communication, to be executed then message with provided type and scopeName is sent to scope.
	 * @param    scopeName            both sending and receiving modules must use same scope to make module to module communication.
	 * @param    type                Message type for command class to react to.
	 * @param    commandClass        Command class that would be executed.
	 */
	public function scopeUnmap(scopeName:String, type:String):void {
		var scopedType:String = scopeName + "_^~_" + type;

		var messageClass:Class = classRegistry[scopedType];
		if (messageClass) {
			ScopeManager.scopedCommandUnmap(handleCommandExecute, scopeName, type);
			delete classRegistry[scopedType];
		}
	}


	override pureLegsCore function dispose():void {
		use namespace pureLegsCore;

		if (classRegistry) {

			for (var type:String in classRegistry) {
				var scopeTypeSplite:Array = type.split("_^~_");
				if (scopeTypeSplite.length > 1) {
					ScopeManager.scopedCommandUnmap(handleCommandExecute, scopeTypeSplite[0], scopeTypeSplite[1]);
				} else {
					messenger.removeHandler(type, handleCommandExecute);
				}
			}
			classRegistry = null;
		}

		//
		var scopeHandlerCount:int = scopeHandlers.length;
		for (var i:int; i < scopeHandlerCount; i++) {
			scopeHandlers[i].handler = null;
		}
		scopeHandlers = null;

		super.dispose()
	}


}
}