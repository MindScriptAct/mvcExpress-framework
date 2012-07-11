package org.mvcexpress.messenger {
import flash.utils.Dictionary;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Framework internal class. Manages module messengers.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MessengerManager {
	
	/** messenger counter, increased with every new created module */
	static private var _messengerCount:int;
	
	/** stores Messenger objects by module name */
	static private var messengerRegistry:Dictionary = new Dictionary(); /* of Messenger by String */
	
	/** CONSTRUCTOR */
	public function MessengerManager() {
		throw Error("MessageManager is static framework class for internal use. Not meant to be instantiated.");
	}
	
	/**
	 * Count of created messengers. (will increase with every new module.)
	 */
	static public function get messengerCount():int {
		return _messengerCount;
	}
	
	/**
	 * Increases messenger count by one. (will be used with every new module.)
	 */
	static pureLegsCore function increaseMessengerCount():void {
		_messengerCount++
	}
	
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