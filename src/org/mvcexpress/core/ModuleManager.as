package org.mvcexpress.core {
import flash.utils.Dictionary;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.mvc.Proxy;
import org.mvcexpress.core.namespace.pureLegsCore;

/**
 * INTERNAR FRAMEWORK CLASS.
 * Creates and manages modules.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleManager {
	
	/* messenger counter, increased with every new created module */
	static private var _moduleId:int;
	
	/* modules stored by moduleName */
	static private var moduleRegistry:Dictionary = new Dictionary(); /* of ModuleBase by String */
	
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
		var retVal:ModuleBase;
		if (moduleRegistry[moduleName] == null) {
			_moduleId++
			//
			if (!moduleName) {
				moduleName = "module" + _moduleId;
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
	 * @private
	 */
	static pureLegsCore function sendMessageToAll(type:String, params:Object):void {
		use namespace pureLegsCore;
		for each (var module:ModuleBase in moduleRegistry) {
			module.messenger.send(type, params);
		}
	}
	/**
	 * Finds all proxy objects that are mapped with given className and name in all modules.
	 * (needed to ensure there are no hosted proxies somethere.)
	 * @param	className
	 * @param	name
	 * @return
	 * @private
	 */
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