package org.mvcexpress.core {
import flash.utils.Dictionary;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * INTERNAR FRAMEWORK CLASS.
 * Creates and manages modules.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleManager {
	
	/** messenger counter, increased with every new created module */
	static private var _messengerCount:int;
	
	/** CONSTRUCTOR */
	public function ModuleManager() {
		throw Error("ModuleFactory is static framework class for internal use. Not meant to be instantiated.");
	}
	
	static pureLegsCore function createModule(moduleName:String, autoInit:Boolean):ModuleBase {
		_messengerCount++
		//
		if (!moduleName) {
			moduleName = "module" + _messengerCount;
		}
		return ModuleBase.getModuleInstance(moduleName, autoInit);
	}
	
	//----------------------------------
	//      TODO ...
	//----------------------------------
	
	/** stores Messenger objects by module name */
	static private var messengerRegistry:Dictionary = new Dictionary(); /* of Messenger by String */
	
	/**
	 * Creates new messenger for module name.
	 * @param	moduleName	name of the module this messenger will belong to.
	 * @return	returns new Messenger.
	 */
	static pureLegsCore function createMessenger(moduleName:String):Messenger {
		var retVal:Messenger;
		use namespace pureLegsCore;
		//
		Messenger.allowInstantiation = true;
		retVal = new Messenger(moduleName);
		Messenger.allowInstantiation = false;
		//
		if (messengerRegistry[moduleName] == null) {
			messengerRegistry[moduleName] = retVal
		} else {
			throw Error("You can't have 2 modules with same name. dispose() old module before creating new one with same name. [moduleName:" + moduleName + "]");
		}
		return retVal;
	}
	
	/**
	 * get messenger for module name.
	 * @param	moduleName		name of the module this messenger will belong to.
	 * @return	returns Messenger object.
	 */
	static pureLegsCore function getMessenger(moduleName:String):Messenger {
		return messengerRegistry[moduleName];
	}
	
	/**
	 * disposes of messenger for module name.
	 * @param	moduleName	name of the module this messenger was belong to.
	 */
	static pureLegsCore function disposeMessenger(moduleName:String):void {
		use namespace pureLegsCore;
		if (messengerRegistry[moduleName]) {
			messengerRegistry[moduleName].dispose();
			messengerRegistry[moduleName] = null;
		} else {
			throw Error("Messenger for moduleName:" + moduleName + " doesn't exist.");
		}
	}
	
	/**
	 * sends message to all messengers.
	 * @param	type				message type to find needed handlers
	 * @param	params				parameter object that will be sent to all handler functions as single parameter.
	 */
	static pureLegsCore function sendMessageToAll(type:String, params:Object):void {
		use namespace pureLegsCore;
		for each (var messenger:Messenger in messengerRegistry) {
			messenger.send(type, params);
		}
	}
}
}