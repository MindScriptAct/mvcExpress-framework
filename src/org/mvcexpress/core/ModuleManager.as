package org.mvcexpress.core {
import flash.utils.Dictionary;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.mvc.Proxy;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * INTERNAR FRAMEWORK CLASS.
 * Creates and manages modules.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleManager {
	
	/** messenger counter, increased with every new created module */
	static private var _messengerCount:int;
	
	/**  */
	static private var moduleRegistry:Dictionary = new Dictionary();
	
	/** CONSTRUCTOR */
	public function ModuleManager() {
		throw Error("ModuleFactory is static framework class for internal use. Not meant to be instantiated.");
	}
	
	static pureLegsCore function createModule(moduleName:String, autoInit:Boolean):ModuleBase {
		var retVal:ModuleBase;
		if (moduleRegistry[moduleName] == null) {
			_messengerCount++
			//
			if (!moduleName) {
				moduleName = "module" + _messengerCount;
			}
			//
			retVal = ModuleBase.getModuleInstance(moduleName, autoInit);
			moduleRegistry[moduleName] = retVal;
				//
		} else {
			throw Error("You can't have 2 modules with same name. call disposeModule() on old module before creating new one with same name. [moduleName:" + moduleName + "]");
		}
		return retVal;
	}
	
	//----------------------------------
	//      TODO ...
	//----------------------------------
	
	/**
	 * get messenger for module name.
	 * @param	moduleName		name of the module this messenger will belong to.
	 * @return	returns Messenger object.
	 */
	static pureLegsCore function getMessenger(moduleName:String):Messenger {
		use namespace pureLegsCore;
		return moduleRegistry[moduleName].messenger;
	}
	
	/**
	 * disposes of messenger for module name.
	 * @param	moduleName	name of the module this messenger was belong to.
	 */
	static pureLegsCore function disposeModule(moduleName:String):void {
		use namespace pureLegsCore;
		if (moduleRegistry[moduleName]) {
			moduleRegistry[moduleName] = null;
		} else {
			throw Error("Module with moduleName:" + moduleName + " doesn't exist.");
		}
	}
	
	/**
	 * sends message to all messengers.
	 * @param	type				message type to find needed handlers
	 * @param	params				parameter object that will be sent to all handler functions as single parameter.
	 */
	static pureLegsCore function sendMessageToAll(type:String, params:Object):void {
		use namespace pureLegsCore;
		for each (var module:ModuleBase in moduleRegistry) {
			module.messenger.send(type, params);
		}
	}
	
	static pureLegsCore function findAllProxies(className:String, name:String):Vector.<Proxy> {
		var retVal:Vector.<Proxy> = new Vector.<Proxy>();
		use namespace pureLegsCore;
		for each (var module:ModuleBase in moduleRegistry) {
			var proxy:Proxy = module.proxyMap.getMappedProxy(className, name);
			if (proxy) {
				retVal.push(proxy);
			}
		}
		return retVal;
	}
}
}