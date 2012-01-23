package org.pureLegs.core {
import org.pureLegs.messenger.Messenger;
import org.pureLegs.mvc.Command;
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
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
	
	private var cashTest:Dictionary = new Dictionary();
	
	public function CommandMap(messanger:Messenger, modelMap:ModelMap, mediatorMap:MediatorMap) {
		this.messanger = messanger;
		this.modelMap = modelMap;
		this.mediatorMap = mediatorMap;
		use namespace pureLegsCore;
		this.messanger.setCommandMapFunction(handleCommandExecute);
	}
	
	public function map(type:String, commandClass:Class):void {
		if (!classRegistry[type]) {
			classRegistry[type] = new Vector.<Class>();
			messanger.addHandler(type, handleCommandExecute);
		}
		
		// TODO : check if command is already added. (in DEBUG mode only.)
		
		classRegistry[type].push(commandClass);
	
	}
	
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
	
	public function execute(commandClass:Class, params:Object = null):void {
		//////////////////////////////////////////////
		////// INLINE FUNCTION runCommand() START
		var command:Command = new commandClass();
		
		use namespace pureLegsCore;
		command.messenger = messanger;
		command.mediatorMap = mediatorMap;
		command.modelMap = modelMap;
		
		command.commandMap = this;
		modelMap.injectStuff(command, commandClass);
		//// debug code
		CONFIG::debug {
			try {
				command.execute(params);
			} catch (error:Error) {
				throw Error("Failed to execute command class : " + commandClass + " " + error);
			}
			return;
		}
		//// release code
		command.execute(params);
		///////////////
	
		////// INLINE FUNCTION runCommand() END
		//////////////////////////////////////////////	
	}
	
	private function handleCommandExecute(type:String, params:Object):void {
		var commandList:Vector.<Class> = classRegistry[type];
		if (commandList) {
			for (var i:int = 0; i < commandList.length; i++) {
				//////////////////////////////////////////////
				////// INLINE FUNCTION runCommand() START
				var command:Command = new commandList[i]();
				
				use namespace pureLegsCore;
				command.messenger = messanger;
				command.mediatorMap = mediatorMap;
				command.modelMap = modelMap;
				
				command.commandMap = this;
				
				modelMap.injectStuff(command, commandList[i]);
				//// debug code
				CONFIG::debug {
					try {
						command.execute(params);
					} catch (error:Error) {
						throw Error("Failed to execute command class : " + commandList[i] + " " + error);
					}
					continue;
				}
				//// release code
				command.execute(params);
				///////////////
				
				////// INLINE FUNCTION runCommand() END
				//////////////////////////////////////////////
			}
		}
	}

}
}