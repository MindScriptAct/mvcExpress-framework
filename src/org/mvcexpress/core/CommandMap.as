// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.core.messenger.HandlerVO;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.commandMap.TraceCommandMap_execute;
import org.mvcexpress.core.traceObjects.commandMap.TraceCommandMap_handleCommandExecute;
import org.mvcexpress.core.traceObjects.commandMap.TraceCommandMap_map;
import org.mvcexpress.core.traceObjects.commandMap.TraceCommandMap_unmap;
import org.mvcexpress.mvc.Command;
import org.mvcexpress.mvc.PooledCommand;
import org.mvcexpress.MvcExpress;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * Handles command mappings, and executes them on messages
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class CommandMap {
	
	// name of the module CommandMap is working for.
	private var moduleName:String;
	
	// for internal use.
	private var messenger:Messenger;
	// for internal use.
	private var proxyMap:ProxyMap;
	// for internal use.
	private var mediatorMap:MediatorMap;
	
	/////////////////
	// mvcExpressLive
	// for internal use.
	private var processMap:ProcessMap;
	/////////////////
	
	// collection of class arrays, stored by message type. Then message with this type is sent, all mapped classes are executed.
	private var classRegistry:Dictionary = new Dictionary(); /* of Vector.<Class> by String */
	
	// holds pooled command objects, stared by command class.
	private var commandPools:Dictionary = new Dictionary(); /* of Vector.<PooledCommand> by Class */
	
	/** types of command execute function, needed for debug mode only validation of execute() parameter.  */
	CONFIG::debug
	static private var commandClassParamTypes:Dictionary = new Dictionary(); /* of String by Class */
	
	/** Dictionary with validated command classes.  */
	CONFIG::debug
	static private var validatedCommands:Dictionary = new Dictionary(); /* of Boolean by Class */
	
	private var scopeHandlers:Vector.<HandlerVO> = new Vector.<HandlerVO>();
	
	/** CONSTRUCTOR */
	public function CommandMap($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap, $mediatorMap:MediatorMap) {
		moduleName = $moduleName;
		messenger = $messenger;
		proxyMap = $proxyMap;
		mediatorMap = $mediatorMap;
	}
	
	//----------------------------------
	//     set up commands to execute current module messages
	//----------------------------------
	
	/**
	 * Map a class to be executed then message with provided type is sent.
	 * @param	type				Message type for command class to react to.
	 * @param	commandClass		Command class that will be executed.
	 */
	public function map(type:String, commandClass:Class):void {
		// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
		use namespace pureLegsCore;
		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceCommandMap_map(moduleName, type, commandClass));
			validateCommandClass(commandClass);
			if (!Boolean(type) || type == "null" || type == "undefined") {
				throw Error("Message type:[" + type + "] can not be empty or 'null' or 'undefined'. (You are trying to map command:" + commandClass + ")");
			}
		}
		var messageClasses:Vector.<Class> = classRegistry[type];
		if (!messageClasses) {
			messageClasses = new Vector.<Class>();
			classRegistry[type] = messageClasses;
			messenger.addCommandHandler(type, handleCommandExecute, commandClass);
		}
		
		// check if command is already added.
		CONFIG::debug {
			var commandCount:int = messageClasses.length;
			for (var i:int = 0; i < commandCount; i++) {
				if (messageClasses[i] == commandClass) {
					throw Error("Command:" + commandClass + " is already mapped to message type:" + type);
				}
			}
		}
		
		messageClasses[messageClasses.length] = commandClass;
	}
	
	/**
	 * Unmaps a class to be executed then message with provided type is sent.
	 * @param	type			Message type for command class to react to.
	 * @param	commandClass	Command class that would be executed.
	 */
	public function unmap(type:String, commandClass:Class):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceCommandMap_unmap(moduleName, type, commandClass));
		}
		var messageClasses:Vector.<Class> = classRegistry[type];
		if (messageClasses) {
			var commandCount:int = messageClasses.length;
			for (var i:int; i < commandCount; i++) {
				if (commandClass == messageClasses[i]) {
					messageClasses.splice(i, 1);
					break;
				}
			}
		}
	}
	
	//----------------------------------
	//     Command execute
	//----------------------------------
	
	/**
	 * Instantiates and executes provided command class, and sends params to it.
	 * @param	commandClass	Command class to be instantiated and executed.
	 * @param	params			Object to be sent to execute() function.
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
			}
			
			// construct command
			CONFIG::debug {
				Command.canConstruct = true;
			}
			command = new commandClass();
			CONFIG::debug {
				Command.canConstruct = false;
			}
			
			command.messenger = messenger;
			command.mediatorMap = mediatorMap;
			command.proxyMap = proxyMap;
			command.commandMap = this;
			/////////////////
			// mvcExpressLive
			command.processMap = processMap;
			/////////////////
			
			// inject dependencies
			proxyMap.injectStuff(command, commandClass);
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
	//     set up commands to execute scoped messages
	//----------------------------------
	
	/**
	 * Maps a class for module to module communication, to be executed then message with provided type and scopeName is sent to scope.
	 * @param	scopeName			both sending and receiving modules must use same scope to make module to module communication.
	 * @param	type				Message type for command class to react to.
	 * @param	commandClass		Command class that will be executed.
	 */
	public function scopeMap(scopeName:String, type:String, commandClass:Class):void {
		use namespace pureLegsCore;
		//
		var scopedType:String = scopeName + "_^~_" + type;
		
		var messageClasses:Vector.<Class> = classRegistry[scopedType];
		if (!messageClasses) {
			messageClasses = new Vector.<Class>();
			classRegistry[scopedType] = messageClasses;
			// add scoped command handler.
			scopeHandlers[scopeHandlers.length] = ModuleManager.scopedCommandMap(moduleName, handleCommandExecute, scopeName, type, commandClass)
		}
		
		// check if command is already added.
		CONFIG::debug {
			var commandCount:int = messageClasses.length;
			for (var i:int = 0; i < commandCount; i++) {
				if (messageClasses[i] == commandClass) {
					throw Error("Command:" + commandClass + " is already mapped to scopeName:" + scopeName + " with message type:" + type);
				}
			}
		}
		
		messageClasses[messageClasses.length] = commandClass;
	}
	
	/**
	 * Unmaps a class for module to module communication, to be executed then message with provided type and scopeName is sent to scope.
	 * @param	scopeName			both sending and receiving modules must use same scope to make module to module communication.
	 * @param	type				Message type for command class to react to.
	 * @param	commandClass		Command class that would be executed.
	 */
	public function scopeUnmap(scopeName:String, type:String, commandClass:Class):void {
		var scopedType:String = scopeName + "_^~_" + type;
		
		var messageClasses:Vector.<Class> = classRegistry[scopedType];
		if (messageClasses) {
			var commandCount:int = messageClasses.length;
			for (var i:int; i < commandCount; i++) {
				if (commandClass == messageClasses[i]) {
					messageClasses.splice(i, 1);
					break;
				}
			}
		}
	}
	
	//----------------------------------
	//     command pooling
	//----------------------------------
	
	/**
	 * Checks if PooledCommand is already pooled.
	 * @param	commandClass
	 * @return	true if command pool is created.
	 */
	public function checkIsClassPooled(commandClass:Class):Boolean {
		return (commandPools[commandClass] != null);
	}
	
	/**
	 * Clears pool created for specified command.
	 * (if commands are not pooled - function fails silently.)
	 * @param	commPoolingSimpleCommand
	 */
	public function clearCommandPool(commandClass:Class):void {
		delete commandPools[commandClass];
	}
	
	//----------------------------------
	//     Debug
	//----------------------------------
	
	/**
	 * Checks if Command class is already added to message type
	 * @param	type			Message type for command class to react to.
	 * @param	commandClass	Command class that will be instantiated and executed.
	 * @return					true if Command class is already mapped to message
	 */
	public function isMapped(type:String, commandClass:Class):Boolean {
		var retVal:Boolean; // = false;
		if (classRegistry[type]) {
			var mappedClasses:Vector.<Class> = classRegistry[type];
			var classCaunt:int = mappedClasses.length;
			for (var i:int; i < classCaunt; i++) {
				if (commandClass == mappedClasses[i]) {
					retVal = true;
				}
			}
		}
		return retVal;
	}
	
	/**
	 * Returns count of commands mapped to specified message type.
	 * @param type		Message type for command class to react to.
	 * @return			count of commands mapped to message.
	 */
	public function mappedCommandCount(type:String):int {
		if (classRegistry[type] != null) {
			return (classRegistry[type] as Vector.<Class>).length;
		} else {
			return 0;
		}
	}
	
	/**
	 * Returns text of all command classes that are mapped to messages. (for debugging)
	 * @return		Text with all mapped commands.
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
	 * Pool command from outside of CommandMap.
	 * @param	command	Command object to be pooled.
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
		for (var type:String in classRegistry) {
			messenger.removeHandler(type, handleCommandExecute);
		}
		//
		var scopeHandlerCount:int = scopeHandlers.length;
		for (var i:int; i < scopeHandlerCount; i++) {
			scopeHandlers[i].handler = null;
		}
		messenger = null;
		proxyMap = null;
		mediatorMap = null;
		classRegistry = null;
		commandPools = null;
	}
	
	/** function to be called by messenger on needed message type sent */
	pureLegsCore function handleCommandExecute(messageType:String, params:Object):void {
		use namespace pureLegsCore;
		
		var command:Command;
		var messageClasses:Vector.<Class>;
		
		messageClasses = classRegistry[messageType];
		if (messageClasses) {
			var commandCount:int = messageClasses.length;
			for (var i:int; i < commandCount; i++) {
				var commandClass:Class = messageClasses[i];
				
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
					
					command.messenger = messenger;
					command.mediatorMap = mediatorMap;
					command.proxyMap = proxyMap;
					command.commandMap = this;
					
					// inject dependencies
					proxyMap.injectStuff(command, commandClass);
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
	}
	
	/**
	 * Helper functions for error checking
	 * @private
	 */
	CONFIG::debug
	pureLegsCore function validateCommandClass(commandClass:Class):void {
		
		// skip alread validated classes.
		if (validatedCommands[commandClass] != true) {
			
			if (!checkClassSuperclass(commandClass, "org.mvcexpress.mvc::Command")) {
				throw Error("commandClass:" + commandClass + " you are trying to map MUST extend: 'org.mvcexpress.mvc::Command' class.");
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
	
	CONFIG::debug
	private function validateCommandParams(commandClass:Class, params:Object):void {
		use namespace pureLegsCore;
		validateCommandClass(commandClass);
		if (params) {
			var paramClass:Class = getDefinitionByName(commandClassParamTypes[commandClass]) as Class;
			
			if (!(params is paramClass)) {
				throw Error("Class " + commandClass + " expects " + commandClassParamTypes[commandClass] + ". But you are sending :" + getQualifiedClassName(params));
			}
		}
	}
	
	// used for debugging
	pureLegsCore function listMessageCommands(messageType:String):Vector.<Class> {
		return classRegistry[messageType];
	}
	
	/////////////////
	// mvcExpressLive
	pureLegsCore function setProcessMap(value:ProcessMap):void {
		processMap = value;
	}
	/////////////////
	

}
}