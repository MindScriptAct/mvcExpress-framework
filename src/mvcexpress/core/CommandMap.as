// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core {
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mvcexpress.MvcExpress;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.commandMap.TraceCommandMap_execute;
import mvcexpress.core.traceObjects.commandMap.TraceCommandMap_handleCommandExecute;
import mvcexpress.core.traceObjects.commandMap.TraceCommandMap_map;
import mvcexpress.core.traceObjects.commandMap.TraceCommandMap_unmap;
import mvcexpress.mvc.Command;
import mvcexpress.mvc.PooledCommand;
import mvcexpress.utils.checkClassSuperclass;

use namespace pureLegsCore;

/**
 * Handles command mappings, and executes them then mapped message string is sent.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class CommandMap {

	// name of the module CommandMap is working for.
	protected var moduleName:String;

	// used internally for communications
	protected var messenger:Messenger;
	// used internally to work with proxies.
	protected var proxyMap:ProxyMap;
	// used internally to handles application mediators.
	protected var mediatorMap:MediatorMap;

	// commands class stored by message type. Then message with this type is sent, mapped class is executed.
	protected var classRegistry:Dictionary = new Dictionary(); //* of Class by String */

	// holds pooled command objects, stared by command class.
	protected var commandPools:Dictionary = new Dictionary(); //* of Vector.<PooledCommand> by Class */

	/** types of command execute function, needed for debug mode only validation of execute() parameter.  */
	CONFIG::debug
	static protected var commandClassParamTypes:Dictionary = new Dictionary(); //* of String by Class */

	/** Dictionary with validated command classes.  */
	CONFIG::debug
	static protected var validatedCommands:Dictionary = new Dictionary(); //* of Boolean by Class */

	/** CONSTRUCTOR */
	public function CommandMap($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap, $mediatorMap:MediatorMap) {
		moduleName = $moduleName;
		messenger = $messenger;
		proxyMap = $proxyMap;
		mediatorMap = $mediatorMap;
	}


	//----------------------------------
	//     set up commands to execute current module constants
	//----------------------------------

	/**
	 * Map a class to be executed then message with provided type is sent.                                                                                                            <p>
	 * Only one command can be mapped to single messageType. Error will be thrown if you attempt to map second command class to same message type, unless canMapOver set to true.    </p>
	 * @param    type                Message type for command class to react to.
	 * @param    commandClass        Command class that will be executed.
	 * @param    canMapOver          Allows mapping command class over already existing command.
	 */
	public function map(type:String, commandClass:Class, canMapOver:Boolean = false):void {
		// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
		use namespace pureLegsCore;

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommandMap_map(moduleName, type, commandClass));
			validateCommandClass(commandClass);
			if (!Boolean(type) || type == "null" || type == "undefined") {
				throw Error("Message type:[" + type + "] can not be empty or 'null' or 'undefined'. (You are trying to map command:" + commandClass + ")");
			}

			// var check if extension is supported by this module.
			var extensionId:int = ExtensionManager.getExtensionId(commandClass);
			if (SUPPORTED_EXTENSIONS[extensionId] == null) {
				throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(commandClass) + " extension enabled to use " + commandClass + " command.");
			}
		}

		if (classRegistry[type]) {
			if (!canMapOver) {
				throw Error("Only one command class can be mapped to one message type. You are trying to map " + commandClass + " to " + type + ", but it is already mapped to " + classRegistry[type]);
			}
		} else {
			messenger.addCommandHandler(type, handleCommandExecute, commandClass);
		}


		classRegistry[type] = commandClass;
	}

	/**
	 * Unmaps a class to be executed then message with provided type is sent.
	 * @param    type        Message type for command class to react to.
	 */
	public function unmap(type:String):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceCommandMap_unmap(moduleName, type, null));
		}
		var messageClasse:Class = classRegistry[type];
		if (messageClasse) {
			messenger.removeHandler(type, handleCommandExecute);
			delete classRegistry[type];
		}
	}


	//----------------------------------
	//     Command execute
	//----------------------------------

	/**
	 * Instantiates and executes provided command class, and sends params to it.
	 * @param    commandClass    Command class to be instantiated and executed.
	 * @param    params            Object to be sent to execute() function.
	 */
	public function execute(commandClass:Class, params:Object = null):void {
		use namespace pureLegsCore;

		var command:Command;

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommandMap_execute(moduleName, command, commandClass, params));
		}

		//////////////////////////////////////////////
		////// INLINE FUNCTION runCommand() START

		// check if command is pooled.
		var pooledCommands:Vector.<PooledCommand> = commandPools[commandClass];
		if (pooledCommands && pooledCommands.length > 0) {
			command = pooledCommands.shift();
		} else {
			// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
			CONFIG::debug {
				validateCommandParams(commandClass, params);

				// var check if extension is supported by this module.
				var extensionId:int = ExtensionManager.getExtensionId(commandClass);
				if (SUPPORTED_EXTENSIONS[extensionId] == null) {
					throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(commandClass) + " extension enabled to use " + commandClass + " command.");
				}
			}

			// construct command
			CONFIG::debug {
				Command.canConstruct = true;
			}
			command = new commandClass();
			CONFIG::debug {
				Command.canConstruct = false;
			}

			prepareCommand(command, commandClass);

		}

		if (command is PooledCommand) {
			// init pool if needed.
			if (!pooledCommands) {
				pooledCommands = new Vector.<PooledCommand>();
				commandPools[commandClass] = pooledCommands;
			}

			command.messageType = null;

			command.isExecuting = true;
			command.execute(params);
			command.isExecuting = false;

			// if not locked - pool it.
			if (!(command as PooledCommand).isLocked) {
				if (pooledCommands) {
					pooledCommands[pooledCommands.length] = command as PooledCommand;
				}
			}
		} else {
			command.isExecuting = true;
			command.execute(params);
			command.isExecuting = false;
		}

		////// INLINE FUNCTION runCommand() END
		//////////////////////////////////////////////

	}


	//----------------------------------
	//     command pooling
	//----------------------------------

	/**
	 * Checks if specific PooledCommand is already pooled.
	 * @param    commandClass    PooledCommand subclass to check Command pool for.
	 * @return    true if command pool is created.
	 */
	public function isCommandPooled(commandClass:Class):Boolean {
		return (commandPools[commandClass] != null);
	}

	/**
	 * Clears all command pools, or specific one.
	 * (if commands are not pooled - function fails silently.)
	 * @param    commandClass Optional Command class to clear specific command pool
	 */
	public function clearCommandPool(commandClass:Class = null):void {
		if (commandClass) {
			delete commandPools[commandClass];
		} else {
			commandPools = new Dictionary();
		}
	}


	//----------------------------------
	//     Debug
	//----------------------------------

	/**
	 * Checks if Command class is already added to message type, or any class.
	 * @param    type            Message type for command class to react to.
	 * @param    commandClass    Optional: Command class that will be instantiated and executed.
	 * @return                    true if Command class is already mapped to message
	 */
	public function isMapped(type:String, commandClass:Class = null):Boolean {
		var retVal:Boolean; // = false;
		if (classRegistry[type]) {
			if (commandClass) {
				retVal = (classRegistry[type] == commandClass);
			} else {
				retVal = true;
			}
		}
		return retVal;
	}

	/**
	 * Returns text of all command classes that are mapped to constants. (for debugging)
	 * @return        Text with all mapped commands.
	 */
	public function listMappings():String {
		var retVal:String = "";
		retVal = "===================== CommandMap Mappings: =====================\n";
		for (var key:String in classRegistry) {
			retVal += "SENDING MESSAGE:'" + key + "'\t> EXECUTES > " + classRegistry[key] + "\n";
		}
		retVal += "================================================================\n";
		return retVal;
	}


	//----------------------------------
	//     INTERNAL
	//----------------------------------

	/**
	 * Prepares command object for work.
	 * @param command
	 * @param commandClass
	 * @private
	 */
	protected function prepareCommand(command:Command, commandClass:Class):void {
		use namespace pureLegsCore;

		command.messenger = messenger;
		command.mediatorMap = mediatorMap;
		command.proxyMap = proxyMap;
		command.commandMap = this;

		// inject dependencies
		proxyMap.injectStuff(command, commandClass);
	}

	/**
	 * Pool command from outside of CommandMap.
	 * @param    command    Command object to be pooled.
	 * @private
	 */
	pureLegsCore function poolCommand(command:PooledCommand):void {
		var commandClass:Class = Object(command).constructor as Class;
		var pooledCommands:Vector.<PooledCommand> = commandPools[commandClass];
		if (pooledCommands) {
			pooledCommands[pooledCommands.length] = command;
		}
	}

	/**
	 * Dispose commandMap on disposeModule()
	 * @private
	 */
	pureLegsCore function dispose():void {
		use namespace pureLegsCore;

		if (classRegistry) {
			for (var type:String in classRegistry) {
				messenger.removeHandler(type, handleCommandExecute);
			}
			classRegistry = null;
		}

		messenger = null;
		proxyMap = null;
		mediatorMap = null;
		commandPools = null;
	}

	/**
	 * function to be called by messenger on needed message type sent
	 * @private
	 */
	pureLegsCore function handleCommandExecute(messageType:String, params:Object):void {
		use namespace pureLegsCore;

		var command:Command;
		var commandClass:Class;

		commandClass = classRegistry[messageType];
		if (commandClass) {

			// debug this action
			CONFIG::debug {
				MvcExpress.debug(new TraceCommandMap_handleCommandExecute(moduleName, command, commandClass, messageType, params));
			}

			//////////////////////////////////////////////
			////// INLINE FUNCTION runCommand() START

			// check if command is pooled.
			var pooledCommands:Vector.<PooledCommand> = commandPools[commandClass];
			if (pooledCommands && pooledCommands.length > 0) {
				command = pooledCommands.shift();
			} else {
				// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
				CONFIG::debug {
					validateCommandParams(commandClass, params);
				}

				// construct command
				CONFIG::debug {
					Command.canConstruct = true;
				}
				command = new commandClass();
				CONFIG::debug {
					Command.canConstruct = false;
				}

				prepareCommand(command, commandClass);
			}

			command.messageType = messageType;

			if (command is PooledCommand) {
				// init pool if needed.
				if (!pooledCommands) {
					pooledCommands = new Vector.<PooledCommand>();
					commandPools[commandClass] = pooledCommands;
				}
				command.isExecuting = true;
				command.execute(params);
				command.isExecuting = false;

				// if not locked - pool it.
				if (!(command as PooledCommand).isLocked) {
					if (pooledCommands) {
						pooledCommands[pooledCommands.length] = command as PooledCommand;
					}
				}
			} else {
				command.isExecuting = true;
				command.execute(params);
				command.isExecuting = false;
			}

			////// INLINE FUNCTION runCommand() END
			//////////////////////////////////////////////

		}
	}

	/**
	 * Helper functions for error checking
	 * @private
	 */
	CONFIG::debug
	pureLegsCore function validateCommandClass(commandClass:Class):void {

		// skip already validated classes.
		if (validatedCommands[commandClass] != true) {

			if (!checkClassSuperclass(commandClass, "mvcexpress.mvc::Command")) {
				throw Error("commandClass:" + commandClass + " you are trying to map MUST extend: 'mvcexpress.mvc::Command' class.");
			}

			if (!commandClassParamTypes[commandClass]) {

				var classDescription:XML = describeType(commandClass);
				var hasExecute:Boolean; // = false;
				var parameterCount:int; // = 0;

				// find execute method.
				var methodList:XMLList = classDescription.factory.method;
				var methodCount:int = methodList.length();
				for (var i:int; i < methodCount; i++) {
					if (methodList[i].@name == "execute") {
						hasExecute = true;
						// check parameter ammount.
						var paramList:XMLList = methodList[i].parameter;
						parameterCount = paramList.length();
						if (parameterCount == 1) {
							commandClassParamTypes[commandClass] = paramList[0].@type;
						}
					}
				}

				if (hasExecute) {
					if (parameterCount != 1) {
						throw Error("Command:" + commandClass + " function execute() must have single parameter, but it has " + parameterCount);
					}
				} else {
					throw Error("Command:" + commandClass + " must have public execute() function with single parameter.");
				}
			}

			validatedCommands[commandClass] = true;
		}
	}

	/** @private */
	CONFIG::debug
	protected function validateCommandParams(commandClass:Class, params:Object):void {
		use namespace pureLegsCore;

		validateCommandClass(commandClass);
		if (params) {
			var paramClass:Class = getDefinitionByName(commandClassParamTypes[commandClass]) as Class;

			if (!(params is paramClass)) {
				throw Error("Class " + commandClass + " expects " + commandClassParamTypes[commandClass] + ". But you are sending :" + getQualifiedClassName(params));
			}
		}
	}

	/**
	 * used for debugging
	 * @private
	 */
	pureLegsCore function getMessageCommand(messageType:String):Class {
		return classRegistry[messageType];
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	pureLegsCore var SUPPORTED_EXTENSIONS:Dictionary;

	/** @private */
	CONFIG::debug
	pureLegsCore function setSupportedExtensions(supportedExtensions:Dictionary):void {
		SUPPORTED_EXTENSIONS = supportedExtensions;
	}


}
}