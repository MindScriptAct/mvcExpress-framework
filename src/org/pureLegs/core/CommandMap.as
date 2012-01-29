package org.pureLegs.core {
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.mvc.Command;
import org.pureLegs.namespace.pureLegsCore;

/**
 * Handles command mappings, and executes them on messages
 * @author rbanevicius
 */
public class CommandMap {
	
	private var messanger:Messenger;
	private var modelMap:ModelMap;
	private var mediatorMap:MediatorMap;
	
	private var classRegistry:Dictionary = new Dictionary();
		
	/** types of command execute function needed for debug mode only validation.  */
	CONFIG::debug
	private var commandClassParamTypes:Dictionary = new Dictionary();
	
	public function CommandMap(messanger:Messenger, modelMap:ModelMap, mediatorMap:MediatorMap) {
		this.messanger = messanger;
		this.modelMap = modelMap;
		this.mediatorMap = mediatorMap;
		use namespace pureLegsCore;
		this.messanger.setCommandMapFunction(handleCommandExecute);
	}
	
	/**
	 * Map a class to be executed then message with type provied is sent.
	 * @param	type			Message type for command class to react to.
	 * @param	commandClass	Command class that will bi instantiated and executed.
	 */
	public function map(type:String, commandClass:Class):void {
		// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
		CONFIG::debug {
			validateCommandClass(commandClass);
		}
		
		if (!classRegistry[type]) {
			classRegistry[type] = new Vector.<Class>();
			messanger.addHandler(type, handleCommandExecute);
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
		CONFIG::debug {
			validateCommandParams(commandClass, params);
		}
		
		var command:Command = new commandClass();
		
		use namespace pureLegsCore;
		command.messenger = messanger;
		command.mediatorMap = mediatorMap;
		command.modelMap = modelMap;
		
		command.commandMap = this;
		modelMap.injectStuff(command, commandClass);
		
		command.execute(params);
	
		////// INLINE FUNCTION runCommand() END
		//////////////////////////////////////////////	
	}
	
	/* function to be called by messenger on needed mesage type sent */
	private function handleCommandExecute(type:String, params:Object):void {
		var commandList:Vector.<Class> = classRegistry[type];
		if (commandList) {
			for (var i:int = 0; i < commandList.length; i++) {
				//////////////////////////////////////////////
				////// INLINE FUNCTION runCommand() START
				
				// check if command has execute function, parameter, and store type of parameter object for future checks on execute.
				CONFIG::debug {
					validateCommandParams(commandList[i], params);
				}
				
				var command:Command = new commandList[i]();
				
				use namespace pureLegsCore;
				command.messenger = messanger;
				command.mediatorMap = mediatorMap;
				command.modelMap = modelMap;
				
				command.commandMap = this;
				
				modelMap.injectStuff(command, commandList[i]);
				
				command.execute(params);
				
					////// INLINE FUNCTION runCommand() END
					//////////////////////////////////////////////
			}
		}
	}
	
	/* Dispose commandMap on module shutDown */
	pureLegsCore function dispose():void {
		messanger = null;
		modelMap = null;
		mediatorMap = null;
		classRegistry = null;
	}
	
	//----------------------------------
	//     Helper funcitons for error checking
	//----------------------------------
	CONFIG::debug
	public function validateCommandClass(commandClass:Class):void {
		
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
		validateCommandClass(commandClass);
		if (params) {
			var paramClass:Class = getDefinitionByName(commandClassParamTypes[commandClass]) as Class;
			
			if (!(params is paramClass)) {
				throw Error("Class " + commandClass + " expects " + commandClassParamTypes[commandClass] + ". But you are sending :" + getQualifiedClassName(params));
			}
		}
	}

}
}