package org.mvcexpress.core {
import flash.utils.Dictionary;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.MvcExpress;

/**
 * INTERNAL FRAMEWORK CLASS.
 * Creates and manages modules.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleManager {
	
	/* messenger counter, increased with every new created module */
	static private var _moduleId:int;
	
	/* modules stored by moduleName */
	static private var moduleRegistry:Dictionary = new Dictionary(); /* of ModuleBase by String */
	
	/* TODO : comment */
	static private var allModules:Vector.<ModuleBase> = new Vector.<ModuleBase>();
	
	/** CONSTRUCTOR */
	public function ModuleManager() {
		throw Error("ModuleFactory is static framework class for internal use. Not meant to be instantiated.");
	}
	
	/**
	 * Creates new module for given name.
	 * @param	moduleName
	 * @param	autoInit
	 * @return
	 * @private
	 */
	static pureLegsCore function createModule(moduleName:String, autoInit:Boolean):ModuleBase {
		trace();
		var retVal:ModuleBase;
		// debug this action
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("#####+ ModuleManager.createModule > moduleName : " + moduleName + ", autoInit : " + autoInit);
			}
		}
		if (moduleRegistry[moduleName] == null) {
			_moduleId++
			//
			if (!moduleName) {
				moduleName = "module" + _moduleId;
			}
			//
			retVal = ModuleBase.getModuleInstance(moduleName, autoInit);
			moduleRegistry[moduleName] = retVal;
			allModules.push(retVal);
				//
		} else {
			throw Error("You can't have 2 modules with same name. call disposeModule() on old module before creating new one with same name. [moduleName:" + moduleName + "]");
		}
		return retVal;
	}
	
	/**
	 * get messenger for module name.
	 * @param	moduleName		name of the module this messenger will belong to.
	 * @return	returns Messenger object.
	 * @private
	 */
	static pureLegsCore function getMessenger(moduleName:String):Messenger {
		use namespace pureLegsCore;
		return moduleRegistry[moduleName].messenger;
	}
	
	/**
	 * disposes of messenger for module name.
	 * @param	moduleName	name of the module this messenger was belong to.
	 * @private
	 */
	static pureLegsCore function disposeModule(moduleName:String):void {
		use namespace pureLegsCore;
		// debug this action
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("#####- ModuleManager.disposeModule > moduleName : " + moduleName);
			}
		}
		if (moduleRegistry[moduleName]) {
			delete moduleRegistry[moduleName];
			for (var j:int = 0; j < allModules.length; j++) {
				if (allModules[j].moduleName == moduleName) {
					allModules.splice(j, 1);
					break;
				}
			}
		} else {
			throw Error("Module with moduleName:" + moduleName + " doesn't exist.");
		}
	}
	
	/**
	 * sends message to all messengers.
	 * @param	type				message type to find needed handlers
	 * @param	params				parameter object that will be sent to all handler functions as single parameter.
	 * @private
	 */
	static pureLegsCore function sendMessageToAll(type:String, params:Object):void {
		use namespace pureLegsCore;
		for (var i:int = 0; i < allModules.length; i++) {
			allModules[i].messenger.send(type, params);
		}
	}
	
	//----------------------------------
	//     DEBUG
	//----------------------------------
	
	/**
	 * Returns string with all module names.
	 * @return
	 */
	static public function listModules():String {
		var retVal:String = "";
		for (var i:int = 0; i < allModules.length; i++) {
			if (retVal != "") {
				retVal += ",";
			}
			retVal += allModules[i].moduleName;
		}
		return "Module list:" + retVal;
	}
	
	static public function listMappedMessages(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return moduleRegistry[moduleName].listMappedMessages();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	static public function listMappedMediators(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return moduleRegistry[moduleName].listMappedMediators();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	static public function listMappedProxies(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return moduleRegistry[moduleName].listMappedProxies();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	static public function listMappedCommands(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return moduleRegistry[moduleName].listMappedCommands();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	static pureLegsCore function listModuleMessageCommands(moduleName:String, key:String):String {
		use namespace pureLegsCore;
		if (moduleRegistry[moduleName]) {
			return moduleRegistry[moduleName].commandMap.listMessageCommands(key);
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}

}
}