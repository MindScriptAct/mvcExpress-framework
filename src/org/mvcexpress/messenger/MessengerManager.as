package org.mvcexpress.messenger {
import flash.utils.Dictionary;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MessengerManager {
	
	/* messenger counter, increased with every new created module */
	static private var _messengerCount:int;
	
	static private var messengerRegistry:Dictionary = new Dictionary();
	
	public function MessengerManager() {
		throw Error("MessageManager is static framework class for internal use. Not bent to be instantiated.");
	}
	
	/**
	 * Count of created messengers. (new messenger is created with every new module.)
	 */
	static public function get messengerCount():int {
		return _messengerCount;
	}
	
	static pureLegsCore function increaseMessengerCount():void {
		_messengerCount++
	}
	
	static pureLegsCore function createMessenger(moduleName:String):Messenger {
		var retVal:Messenger;
		use namespace pureLegsCore;
		//
		Messenger.allowInstantiation = true;
		retVal = new Messenger();
		Messenger.allowInstantiation = false;
		//
		if (messengerRegistry[moduleName] == null) {
			messengerRegistry[moduleName] = retVal
		} else {
			throw Error("You can't have 2 modules with same name. dispose() old module before creating new one with same name.");
		}
		return retVal;
	}
	
	static pureLegsCore function getMessenger(moduleName:String):Messenger {
		return messengerRegistry[moduleName];
	}
	
	static pureLegsCore function disposeMessenger(moduleName:String):void {
		use namespace pureLegsCore;
		if (messengerRegistry[moduleName]) {
			messengerRegistry[moduleName].dispose();
			messengerRegistry[moduleName] = null;
		} else {
			throw Error("Messenger for moduleName:" + moduleName + " doesn't exist.");
		}
	}
	
	static pureLegsCore function sendMessageToAll(type:String, params:Object):void {
		use namespace pureLegsCore;
		for each (var messenger:Messenger in messengerRegistry) {
			messenger.send(type, params);
		}
	}

}
}