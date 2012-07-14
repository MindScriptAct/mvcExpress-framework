// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.mvc.Command;
import org.mvcexpress.MvcExpress;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * Handles command mappings, and executes them on messages
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class CommandMap {
	
	private var moduleName:String;
	private var messenger:Messenger;
	private var proxyMap:ProxyMap;
	private var mediatorMap:MediatorMap;
	
	// collection of class arrays, stored by message type. Then message with this type is sent, all mapped classes are executed.
	private var classRegistry:Dictionary = new Dictionary(); /* of Vector.<Class> by String */
	
	/** types of command execute function, needed for debug mode only validation of execute() parameter.  */
	CONFIG::debug
	private var commandClassParamTypes:Dictionary = new Dictionary(); /* of String by Class */
	
	/** CONSTRUCTOR */
	public function CommandMap(moduleName:String, messenger:Messenger, proxyMap:ProxyMap, mediatorMap:MediatorMap) {
		this.moduleName = moduleName;
		this.messenger = messenger;
		this.proxyMap = proxyMap;
		this.mediatorMap = mediatorMap;
	}
	
	/**
	 * Map a class to be executed then message with type provied is sent.
	 * @param	type				Message type for command class to react to.
	 * @param	commandClass		Command class that will bi instantiated and executed.
	 * @param	remoteModuleName	TODO:COMMENT
	 */
	public function map(type:String, commandClass:Class, remoteModuleName:String = null):void {
		// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
		use namespace pureLegsCore;
		// debug this action
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("+ CommandMap.map > type : " + type + ", commandClass : " + commandClass);
			}
			validateCommandClass(commandClass);
			if (!Boolean(type) || type == "null" || type == "undefined") {
				throw Error("Message type:[" + type + "] can not be empty or 'null'. (You are trying to map command:" + commandClass + ")");
			}
		}
		if (!classRegistry[type]) {
			classRegistry[type] = new Vector.<Class>();
			messenger.addCommandHandler(type, handleCommandExecute, commandClass);
		}
		if (remoteModuleName) {
			ModuleManager.addRemoteHandler(type, handleCommandExecute, moduleName, remoteModuleName, commandClass);
		}
		// TODO : check if command is already added. (in DEBUG mode only?.)
		classRegistry[type].push(commandClass);
	}
	
	/**
	 * Unap a class to be executed then message with type provied is sent.
	 * @param	type			Message type for command class to react to.
	 * @param	commandClass	Command class that will bi instantiated and executed.
	 */
	public function unmap(type:String, commandClass:Class):void {
		// debug this action
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("- CommandMap.unmap > type : " + type + ", commandClass : " + commandClass);
			}
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
		
		//////////////////////////////////////////////
		////// INLINE FUNCTION runCommand() START
		// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
		// debug this action
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("* CommandMap.execute > commandClass : " + commandClass + ", params : " + params);
			}
			validateCommandParams(commandClass, params);
		}
		
		CONFIG::debug {
			Command.canConstruct = true;
		}
		var command:Command = new commandClass();
		CONFIG::debug {
			Command.canConstruct = false;
		}
		
		use namespace pureLegsCore;
		command.messenger = messenger;
		command.mediatorMap = mediatorMap;
		command.proxyMap = proxyMap;
		
		command.commandMap = this;
		proxyMap.injectStuff(command, commandClass);
		
		// TODO: check possibility to not send params if it is null.
		// TODO: check possibility to send more then one param object.
		command.execute(params);
	
		////// INLINE FUNCTION runCommand() END
		//////////////////////////////////////////////	
	}
	
	/** function to be called by messenger on needed mesage type sent */
	private function handleCommandExecute(messageType:String, params:Object):void {
		var commandList:Vector.<Class> = classRegistry[messageType];
		if (commandList) {
			for (var i:int = 0; i < commandList.length; i++) {
				//////////////////////////////////////////////
				////// INLINE FUNCTION runCommand() START
				
				// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
				CONFIG::debug {
					validateCommandParams(commandList[i], params);
				}
				
				CONFIG::debug {
					Command.canConstruct = true;
				}
				var command:Command = new commandList[i]();
				CONFIG::debug {
					Command.canConstruct = false;
				}
				
				use namespace pureLegsCore;
				command.messenger = messenger;
				command.mediatorMap = mediatorMap;
				command.proxyMap = proxyMap;
				
				command.commandMap = this;
				
				proxyMap.injectStuff(command, commandList[i]);
				// debug this action
				CONFIG::debug {
					if (MvcExpress.debugFunction != null) {
						MvcExpress.debugFunction("* CommandMap.handleCommandExecute > messageType : " + messageType + ", params : " + params + " Executed with : " + commandList[i]);
					}
				}
				command.execute(params);
				
					////// INLINE FUNCTION runCommand() END
					//////////////////////////////////////////////
			}
		}
	}
	
	/**
	 * Dispose commandMap on module shutDown
	 * @private
	 */
	pureLegsCore function dispose():void {
		use namespace pureLegsCore;
		for (var type:String in classRegistry) {
			messenger.removeHandler(type, handleCommandExecute);
		}
		messenger = null;
		proxyMap = null;
		mediatorMap = null;
		classRegistry = null;
	}
	
	/**
	 * Helper funcitons for error checking
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
			var methodList:XMLList = classDescription.factory.method //.(name() == "execute");
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
	 * @param	commandClass	Command class that will bi instantiated and executed.
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

}
}