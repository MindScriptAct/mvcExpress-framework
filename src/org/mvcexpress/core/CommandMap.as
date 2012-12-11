// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.core.messenger.HandlerVO;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceCommandMap_execute;
import org.mvcexpress.core.traceObjects.TraceCommandMap_handleCommandExecute;
import org.mvcexpress.core.traceObjects.TraceCommandMap_map;
import org.mvcexpress.core.traceObjects.TraceCommandMap_unmap;
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
	
	private var messenger:Messenger;
	private var proxyMap:ProxyMap;
	private var mediatorMap:MediatorMap;
	
	// collection of class arrays, stored by message type. Then message with this type is sent, all mapped classes are executed.
	private var classRegistry:Dictionary = new Dictionary(); /* of Vector.<Class> by String */
	
	// holds pooled command objects, stared by command class.
	private var commandPools:Dictionary = new Dictionary(); /* of Vector.<Object> by Class */
	
	/** types of command execute function, needed for debug mode only validation of execute() parameter.  */
	CONFIG::debug
	private var commandClassParamTypes:Dictionary = new Dictionary(); /* of String by Class */
	
	private var scopeHandlers:Vector.<HandlerVO> = new Vector.<HandlerVO>();
	
	/** CONSTRUCTOR */
	public function CommandMap(moduleName:String, messenger:Messenger, proxyMap:ProxyMap, mediatorMap:MediatorMap) {
		this.moduleName = moduleName;
		this.messenger = messenger;
		this.proxyMap = proxyMap;
		this.mediatorMap = mediatorMap;
	}
	
	/**
	 * Map a class to be executed then message with provided type is sent.
	 * @param	type				Message type for command class to react to.
	 * @param	commandClass		Command class that will be instantiated and executed.
	 */
	public function map(type:String, commandClass:Class):void {
		// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
		use namespace pureLegsCore;
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceCommandMap_map(MvcTraceActions.COMMANDMAP_MAP, moduleName, type, commandClass));
			validateCommandClass(commandClass);
			if (!Boolean(type) || type == "null" || type == "undefined") {
				throw Error("Message type:[" + type + "] can not be empty or 'null' or 'undefined'. (You are trying to map command:" + commandClass + ")");
			}
		}
		if (!classRegistry[type]) {
			classRegistry[type] = new Vector.<Class>();
			messenger.addCommandHandler(type, handleCommandExecute, commandClass);
		}
		// TODO : check if command is already added. (in DEBUG mode only?.)
		classRegistry[type].push(commandClass);
	}
	
	/**
	 * Unmap a class to be executed then message with provided type is sent.
	 * @param	type			Message type for command class to react to.
	 * @param	commandClass	Command class that will be instantiated and executed.
	 */
	public function unmap(type:String, commandClass:Class):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceCommandMap_unmap(MvcTraceActions.COMMANDMAP_UNMAP, moduleName, type, commandClass));
		}
		var commandList:Vector.<Class> = classRegistry[type];
		if (commandList) {
			for (var i:int = 0; i < commandList.length; i++) {
				if (commandClass == commandList[i]) {
					commandList.splice(i, 1);
					break;
				}
			}
		}
	}
	
	/**
	 * Instantiates and executes provided command class, and sends params to it.
	 * @param	commandClass	Command class to be instantiated and executed.
	 * @param	params			Object to be sent to execute() function.
	 */
	public function execute(commandClass:Class, params:Object = null):void {
		var command:Command;
		use namespace pureLegsCore;
		
		//////////////////////////////////////////////
		////// INLINE FUNCTION runCommand() START
		
		// check if command is pooled.
		if (commandPools[commandClass] && commandPools[commandClass].length > 0) {
			command = commandPools[commandClass].shift();
		} else {
			// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
			CONFIG::debug {
				validateCommandParams(commandClass, params);
			}
			
			// consturct command
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
		
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceCommandMap_execute(MvcTraceActions.COMMANDMAP_EXECUTE, moduleName, command, commandClass, params));
		}
		
		if (command is PooledCommand) {
			// init pool if needed.
			if (!commandPools[commandClass]) {
				commandPools[commandClass] = new Vector.<Object>();
			}
			command.isExecuting = true;
			command.execute(params);
			command.isExecuting = false;
			
			// if not locked - pool it.
			if (!(command as PooledCommand).isLocked) {
				if (commandPools[commandClass]) {
					commandPools[commandClass].push(command);
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
	//     SCOPE 
	//----------------------------------
	
	/**
	 * Map a class to be executed then message with provided type and scopeName is sent to maped scope.
	 * @param	scopeName			both sending and receiving modules must use same scope to make module to module comminication.
	 * @param	type				Message type for command class to react to.
	 * @param	commandClass		Command class that will be instantiated and executed.
	 */
	public function scopeMap(scopeName:String, type:String, commandClass:Class):void {
		use namespace pureLegsCore;
		//
		var scopedType:String = scopeName + "_^~_" + type;
		if (!classRegistry[scopedType]) {
			classRegistry[scopedType] = new Vector.<Class>();
			// TODO : check if chonnelCommandMap must be here...
			scopeHandlers.push(ModuleManager.scopedCommandMap(handleCommandExecute, scopeName, type, commandClass));
		}
		// TODO : check if command is already added. (in DEBUG mode only?.)
		classRegistry[scopedType].push(commandClass);
	}
	
	/**
	 * Unmaps a class to be executed then message with provided type and scopeName is sent to maped scope.
	 * @param	scopeName			both sending and receiving modules must use same scope to make module to module comminication.
	 * @param	type				Message type for command class to react to.
	 * @param	commandClass		Command class that will be instantiated and executed.
	 */
	public function scopeUnmap(scopeName:String, type:String, commandClass:Class):void {
		var scopedType:String = scopeName + "_^~_" + type;
		
		var commandList:Vector.<Class> = classRegistry[scopedType];
		if (commandList) {
			for (var i:int = 0; i < commandList.length; i++) {
				if (commandClass == commandList[i]) {
					commandList.splice(i, 1);
					break;
				}
			}
		}
	}
	
	//----------------------------------
	//     INTERNAL
	//----------------------------------
	
	/** function to be called by messenger on needed message type sent */
	pureLegsCore function handleCommandExecute(messageType:String, params:Object):void {
		var commandList:Vector.<Class>;
		var command:Command;
		use namespace pureLegsCore;
		
		commandList = classRegistry[messageType];
		if (commandList) {
			for (var i:int = 0; i < commandList.length; i++) {
				var commandClass:Class = commandList[i];
				
				//////////////////////////////////////////////
				////// INLINE FUNCTION runCommand() START
				
				// check if command is pooled.
				if (commandPools[commandClass] && commandPools[commandClass].length > 0) {
					command = commandPools[commandClass].shift();
				} else {
					// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
					CONFIG::debug {
						validateCommandParams(commandClass, params);
					}
					
					// consturct command
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
				
				// debug this action
				CONFIG::debug {
					use namespace pureLegsCore;
					MvcExpress.debug(new TraceCommandMap_handleCommandExecute(MvcTraceActions.COMMANDMAP_HANDLECOMMANDEXECUTE, moduleName, command, commandClass, messageType, params));
				}
				
				if (command is PooledCommand) {
					// init pool if needed.
					if (!commandPools[commandClass]) {
						commandPools[commandClass] = new Vector.<Object>();
					}
					command.isExecuting = true;
					command.execute(params);
					command.isExecuting = false;
					
					// if not locked - pool it.
					if (!(command as PooledCommand).isLocked) {
						if (commandPools[commandClass]) {
							commandPools[commandClass].push(command);
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
	 * Dispose commandMap on disposeModule()
	 * @private
	 */
	pureLegsCore function dispose():void {
		use namespace pureLegsCore;
		for (var type:String in classRegistry) {
			messenger.removeHandler(type, handleCommandExecute);
		}
		//
		for (var i:int = 0; i < scopeHandlers.length; i++) {
			scopeHandlers[i].handler = null;
		}
		messenger = null;
		proxyMap = null;
		mediatorMap = null;
		classRegistry = null;
		commandPools = null;
	}
	
	/**
	 * Helper functions for error checking
	 * @private
	 */
	CONFIG::debug
	pureLegsCore function validateCommandClass(commandClass:Class):void {
		
		if (!checkClassSuperclass(commandClass, "org.mvcexpress.mvc::Command")) {
			throw Error("commandClass:" + commandClass + " you are trying to map MUST extend: 'org.mvcexpress.mvc::Command' class.");
		}
		
		if (!commandClassParamTypes[commandClass]) {
			
			var classDescription:XML = describeType(commandClass);
			var hasExecute:Boolean = false;
			var parameterCount:int = 0;
			
			// TODO : optimize..
			var methodList:XMLList = classDescription.factory.method;
			for (var i:int = 0; i < methodList.length(); i++) {
				if (methodList[i].@name == "execute") {
					hasExecute = true;
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
		var retVal:Boolean = false;
		if (classRegistry[type]) {
			var mappedClasses:Vector.<Class> = classRegistry[type];
			for (var i:int = 0; i < mappedClasses.length; i++) {
				if (commandClass == mappedClasses[i]) {
					retVal = true;
				}
			}
		}
		return retVal;
	}
	
	/**
	 * Returns text of all command classes that are mapped to messages.
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
	
	pureLegsCore function listMessageCommands(messageType:String):Vector.<Class> {
		return classRegistry[messageType];
	}
	
	//----------------------------------
	//     command pooling
	//----------------------------------
	
	/**
	 * Checks if PooledCommand is already pooled.
	 * @param	commandClass
	 * @return
	 */
	public function checkIsClassPooled(commandClass:Class):Boolean {
		return (commandPools[commandClass] != null);
	}
	
	/**
	 * Clears pool created for specified command. (if command is not pooled - function fails silently.)
	 * @param	commPoolingSimpleCommand
	 */
	public function clearCommandPool(cammandClass:Class):void {
		delete commandPools[cammandClass];
	}
	
	/**
	 * Pool command from outside of CommandMap.
	 * @param	command	Command objcet to be pooled.
	 * @private
	 */
	pureLegsCore function poolCommand(command:PooledCommand):void {
		var commandClass:Class = Object(command).constructor as Class;
		if (commandPools[commandClass]) {
			commandPools[commandClass].push(command);
		}
	}
}
}