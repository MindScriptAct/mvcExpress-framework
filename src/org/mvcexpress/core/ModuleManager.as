// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.utils.Dictionary;
import org.mvcexpress.core.inject.InjectRuleVO;
import org.mvcexpress.core.messenger.HandlerVO;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceModuleManager_createModule;
import org.mvcexpress.core.traceObjects.TraceModuleManager_disposeModule;
import org.mvcexpress.mvc.Proxy;
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
	
	/* all modules stared by module name */
	static private var allModules:Vector.<ModuleBase> = new Vector.<ModuleBase>();
	
	/* all messengers by scope name */
	static private var scopedMessengers:Dictionary = new Dictionary(); /* of Messenger by String{moduleName} */
	
	/* all proxies by scope name */
	static private var scopedProxyMaps:Dictionary = new Dictionary(); /* of ProxyMap by String{moduleName} */
	
	/* all proxies maped to scope */
	static private var scopedProxiesByScope:Dictionary = new Dictionary(); /* of Dictionary(of ProxyMap by Proxy) by String{moduleName} */
	
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
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceModuleManager_createModule(MvcTraceActions.MODULEMANAGER_CREATEMODULE, moduleName, autoInit));
		}
		if (moduleRegistry[moduleName] == null) {
			_moduleId++;
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
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceModuleManager_disposeModule(MvcTraceActions.MODULEMANAGER_DISPOSEMODULE, moduleName));
		}
		if (moduleRegistry[moduleName]) {
			// TODO : optimize unmaping for module disposing
			// remove scoped proxies from this module
			var scopiedProxies:Dictionary = scopedProxiesByScope[moduleName];
			if (scopiedProxies) {
				//for each (var scopedProxyData:ScopedProxyData in scopiedProxies) {
				//var scopedProxy:Proxy = scopedProxyData.scopedProxyMap.getProxy(scopedProxyData.injectClass, scopedProxyData.name);
				//delete scopiedProxies[scopedProxy];
				//scopedProxyData.scopedProxyMap.scopeUnmap(scopedProxyData.scopeName, scopedProxyData.injectClass, scopedProxyData.name);
				//}
				
				for (var injectId:String in scopiedProxies) {
					var scopedProxyData:ScopedProxyData = scopiedProxies[injectId];
					var scopedProxyMap:ProxyMap = scopedProxyMaps[scopedProxyData.scopeName];
					scopedProxyMap.unmap(scopedProxyData.injectClass, scopedProxyData.name);
					delete scopiedProxies[injectId];
				}
			}
			//
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
	
	//----------------------------------
	//     message scoping
	//----------------------------------
	
	/** sends scoped message
	 * @private */
	static pureLegsCore function sendScopeMessage(scopeName:String, type:String, params:Object):void {
		use namespace pureLegsCore;
		var scopeMesanger:Messenger = scopedMessengers[scopeName];
		if (scopeMesanger) {
			scopeMesanger.send(scopeName + "_^~_" + type, params);
		}
	}
	
	/** add scoped handler
	 * @private */
	static pureLegsCore function addScopeHandler(scopeName:String, type:String, handler:Function):HandlerVO {
		var scopeMesanger:Messenger = scopedMessengers[scopeName];
		if (!scopeMesanger) {
			use namespace pureLegsCore;
			Messenger.allowInstantiation = true;
			scopeMesanger = new Messenger("$scope_" + scopeName);
			Messenger.allowInstantiation = false;
			scopedMessengers[scopeName] = scopeMesanger;
		}
		return scopeMesanger.addHandler(scopeName + "_^~_" + type, handler);
	}
	
	/** remove scoped handler
	 * @private */
	static pureLegsCore function removeScopeHandler(scopeName:String, type:String, handler:Function):void {
		//use namespace pureLegsCore;
		var scopeMesanger:Messenger = scopedMessengers[scopeName];
		if (scopeMesanger) {
			scopeMesanger.removeHandler(scopeName + "_^~_" + type, handler);
		}
	}
	
	//----------------------------------
	//     Command scoping
	//----------------------------------
	
	/**
	 * Map command to scoped message.
	 * @param	handleCommandExecute
	 * @param	scopeName
	 * @param	type
	 * @param	commandClass
	 * @return
	 * @private
	 */
	static pureLegsCore function scopedCommandMap(handleCommandExecute:Function, scopeName:String, type:String, commandClass:Class):HandlerVO {
		var scopeMesanger:Messenger = scopedMessengers[scopeName];
		if (!scopeMesanger) {
			use namespace pureLegsCore;
			Messenger.allowInstantiation = true;
			scopeMesanger = new Messenger("$scope_" + scopeName);
			Messenger.allowInstantiation = false;
			scopedMessengers[scopeName] = scopeMesanger;
		}
		return scopeMesanger.addCommandHandler(scopeName + "_^~_" + type, handleCommandExecute, commandClass);
	}
	
	//----------------------------------
	//     proxy scoping
	//----------------------------------
	
	/**
	 * Map proxy to scope
	 * @param	moduleName
	 * @param	scopeName
	 * @param	proxyObject
	 * @param	injectClass
	 * @param	name
	 * @private
	 */
	static pureLegsCore function scopeMap(moduleName:String, scopeName:String, proxyObject:Proxy, injectClass:Class, name:String):void {
		var scopedProxyMap:ProxyMap = scopedProxyMaps[scopeName];
		if (!scopedProxyMap) {
			initScopedProxyMap(scopeName);
			scopedProxyMap = scopedProxyMaps[scopeName];
		}
		var injectId:String = scopedProxyMap.map(proxyObject, injectClass, name);
		
		// add scope to proxy so it could send scoped messages.
		use namespace pureLegsCore;
		proxyObject.addScope(scopeName);
		
		// if injectClass is not provided - proxyClass will be used instead.
		
		// TODO : optimize unmaping for module disposing
		
		var scopedProxyData:ScopedProxyData = new ScopedProxyData();
		scopedProxyData.scopedProxy = proxyObject;
		scopedProxyData.scopeName = scopeName;
		if (injectClass) {
			scopedProxyData.injectClass = injectClass;
		} else {
			scopedProxyData.injectClass = Object(proxyObject).constructor as Class;
		}
		scopedProxyData.name = name;
		//
		if (scopedProxiesByScope[moduleName] == null) {
			scopedProxiesByScope[moduleName] = new Dictionary(true);
		}
		scopedProxiesByScope[moduleName][injectId] = scopedProxyData;
	}
	
	/**
	 * Unmap proxy from scope
	 * @param	moduleName
	 * @param	scopeName
	 * @param	injectClass
	 * @param	name
	 * @private
	 */
	static pureLegsCore function scopeUnmap(moduleName:String, scopeName:String, injectClass:Class, name:String):void {
		var scopedProxyMap:ProxyMap = scopedProxyMaps[scopeName];
		if (scopedProxyMap) {
			// TODO : optimize unmaping for module disposing
			var injectId:String = scopedProxyMap.unmap(injectClass, name);
			// remove scope from proxy, so it would stop sending scoped messages.
			use namespace pureLegsCore;
			scopedProxiesByScope[moduleName][injectId].scopedProxy.removeScope(scopeName);
			delete scopedProxiesByScope[moduleName][injectId];
		}
	}
	
	/**
	 * Inject Scoped proxy.
	 * @param	object
	 * @param	injectRule
	 * @return
	 * @private
	 */
	static pureLegsCore function injectScopedProxy(object:Object, injectRule:InjectRuleVO):Boolean {
		var scopedProxyMap:ProxyMap = scopedProxyMaps[injectRule.scopeName];
		if (scopedProxyMap) {
			use namespace pureLegsCore;
			var ijectProxy:Proxy = scopedProxyMap.getProxyById(injectRule.injectClassAndName);
			if (ijectProxy) {
				object[injectRule.varName] = ijectProxy;
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Adds pending scoped injection.
	 * @param	scopeName
	 * @param	injectClassAndName
	 * @param	pendingInject
	 * @private
	 */
	static pureLegsCore function addPendingScopedInjection(scopeName:String, injectClassAndName:String, pendingInject:Object):void {
		trace("ModuleManager.addPendingScopedInjection > scopeName : " + scopeName + ", injectClassAndName : " + injectClassAndName + ", pendingInject : " + pendingInject);
		var scopedProxyMap:ProxyMap = scopedProxyMaps[scopeName];
		if (!scopedProxyMap) {
			initScopedProxyMap(scopeName);
			scopedProxyMap = scopedProxyMaps[scopeName];
		}
		use namespace pureLegsCore;
		scopedProxyMap.addPendingInjection(injectClassAndName, pendingInject);
	}
	
	/**
	 * Initiates scoped proxy map.
	 * @param	scopeName
	 */
	static private function initScopedProxyMap(scopeName:String):void {
		var scopedMesanger:Messenger = scopedMessengers[scopeName];
		if (!scopedMesanger) {
			use namespace pureLegsCore;
			Messenger.allowInstantiation = true;
			scopedMesanger = new Messenger("$scope_" + scopeName);
			Messenger.allowInstantiation = false;
			scopedMessengers[scopeName] = scopedMesanger;
		}
		scopedProxyMaps[scopeName] = new ProxyMap("$scope_" + scopeName, scopedMesanger);
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
			return (moduleRegistry[moduleName] as ModuleBase).listMappedMessages();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	static public function listMappedMediators(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return (moduleRegistry[moduleName] as ModuleBase).listMappedMediators();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	static public function listMappedProxies(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return (moduleRegistry[moduleName] as ModuleBase).listMappedProxies();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	static public function listMappedCommands(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return (moduleRegistry[moduleName] as ModuleBase).listMappedCommands();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	static pureLegsCore function listModuleMessageCommands(moduleName:String, key:String):String {
		use namespace pureLegsCore;
		if (moduleRegistry[moduleName]) {
			return ((moduleRegistry[moduleName] as ModuleBase).commandMap.listMessageCommands(key) as String);
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}
	
	//----------------------------------
	//     DEPRICATED
	//----------------------------------
	
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

}
}

import org.mvcexpress.mvc.Proxy;

class ScopedProxyData {
	public var scopedProxy:Proxy;
	public var scopeName:String;
	public var injectClass:Class;
	public var name:String;
}