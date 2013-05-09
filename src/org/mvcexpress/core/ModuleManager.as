// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.utils.Dictionary;
import org.mvcexpress.core.inject.InjectRuleVO;
import org.mvcexpress.core.inject.PendingInject;
import org.mvcexpress.core.inject.testInject;
import org.mvcexpress.core.messenger.HandlerVO;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.moduleManager.TraceModuleManager_createModule;
import org.mvcexpress.core.traceObjects.moduleManager.TraceModuleManager_disposeModule;
import org.mvcexpress.core.traceObjects.moduleManager.TraceModuleManager_registerScope;
import org.mvcexpress.core.traceObjects.moduleManager.TraceModuleManager_unregisterScope;
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
	
	static private var needMetadataTest:Boolean = true;
	
	/* all module permision datas by modleName and scopeName */
	static private var scopePermissionsRegistry:Dictionary = new Dictionary(); /* of Dictionary (of ScopePermissionData by scopeName String) by moduleName String */
	
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
		
		// tests if framework can read 'Inject' metadata tag.
		if (needMetadataTest) {
			needMetadataTest = false;
			var injectTest:testInject = new testInject();
			if (!injectTest.testInjectMetaTag()) {
				throw Error("mvcExpress framework failed to use 'Inject' metadata. Please add '-keep-as3-metadata+=Inject' to compile arguments.");
			}
		}
		
		var retVal:ModuleBase;
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceModuleManager_createModule(moduleName, autoInit));
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
			allModules[allModules.length] = retVal;
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
			MvcExpress.debug(new TraceModuleManager_disposeModule(moduleName));
		}
		if (moduleRegistry[moduleName]) {
			// remove scoped proxies from this module
			var scopiedProxies:Dictionary = scopedProxiesByScope[moduleName];
			if (scopiedProxies) {
				// remove scoped proxies.
				for each (var scopedProxyData:ScopedProxyData in scopiedProxies) {
					var scopedProxyMap:ProxyMap = scopedProxyMaps[scopedProxyData.scopeName];
					scopedProxyMap.unmap(scopedProxyData.injectClass, scopedProxyData.name);
					delete scopiedProxies[scopedProxyData.injectId];
				}
			}
			//
			delete moduleRegistry[moduleName];
			var moduleCount:int = allModules.length;
			for (var j:int; j < moduleCount; j++) {
				if (allModules[j].moduleName == moduleName) {
					allModules.splice(j, 1);
					break;
				}
			}
			//
			delete scopePermissionsRegistry[moduleName];
		} else {
			throw Error("Module with moduleName:" + moduleName + " doesn't exist.");
		}
	}
	
	//----------------------------------
	//     message scoping
	//----------------------------------
	
	/** sends scoped message
	 * @private */
	static pureLegsCore function sendScopeMessage(moduleName:String, scopeName:String, type:String, params:Object, checkPermisions:Boolean = true):void {
		use namespace pureLegsCore;
		
		if (checkPermisions) {
			
			// get permission object
			if (scopePermissionsRegistry[moduleName]) {
				var scopePermission:ScopePermissionData = scopePermissionsRegistry[moduleName][scopeName];
			}
			
			// check if action is available
			if (!scopePermission || !scopePermission.messageSending) {
				throw Error("Module with name:" + moduleName + " has no permition to send messages to scope:" + scopeName + ". Please use: registerScopeTest() function.");
			}
		}
		
		// send messages
		var scopeMesanger:Messenger = scopedMessengers[scopeName];
		if (scopeMesanger) {
			scopeMesanger.send(scopeName + "_^~_" + type, params);
		}
	}
	
	/** add scoped handler
	 * @private */
	static pureLegsCore function addScopeHandler(moduleName:String, scopeName:String, type:String, handler:Function):HandlerVO {
		
		// get permission object
		if (scopePermissionsRegistry[moduleName]) {
			var scopePermission:ScopePermissionData = scopePermissionsRegistry[moduleName][scopeName];
		}
		
		// check if action is available
		if (!scopePermission || !scopePermission.messageReceiving) {
			throw Error("Module with name:" + moduleName + " has no permition to receive messages from scope:" + scopeName + ". Please use: registerScopeTest() function.");
		}
		
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
	static pureLegsCore function scopedCommandMap(moduleName:String, handleCommandExecute:Function, scopeName:String, type:String, commandClass:Class):HandlerVO {
		
		// get permission object
		if (scopePermissionsRegistry[moduleName]) {
			var scopePermission:ScopePermissionData = scopePermissionsRegistry[moduleName][scopeName];
		}
		
		// check if action is available
		if (!scopePermission || !scopePermission.messageReceiving) {
			throw Error("Module with name:" + moduleName + " has no permition to receive messages and execute commands from scope:" + scopeName + ". Please use: registerScopeTest() function.");
		}
		
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
		
		// get permission object
		if (scopePermissionsRegistry[moduleName]) {
			var scopePermission:ScopePermissionData = scopePermissionsRegistry[moduleName][scopeName];
		}
		
		// check if action is available
		if (!scopePermission || !scopePermission.proxieMapping) {
			throw Error("Module with name:" + moduleName + " has no permition to map proxies to scope:" + scopeName + ". Please use: registerScopeTest() function.");
		}
		
		use namespace pureLegsCore;
		var scopedProxyMap:ProxyMap = scopedProxyMaps[scopeName];
		if (!scopedProxyMap) {
			initScopedProxyMap(scopeName);
			scopedProxyMap = scopedProxyMaps[scopeName];
		}
		var injectId:String = scopedProxyMap.map(proxyObject, injectClass, name);
		
		// add scope to proxy so it could send scoped messages.
		proxyObject.addScope(scopeName);
		
		var scopedProxyData:ScopedProxyData = new ScopedProxyData();
		scopedProxyData.scopedProxy = proxyObject;
		scopedProxyData.scopeName = scopeName;
		scopedProxyData.injectId = injectId;
		// if injectClass is not provided - proxyClass will be used instead.
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
			var injectId:String = scopedProxyMap.unmap(injectClass, name);
			// remove scope from proxy, so it would stop sending scoped messages.
			use namespace pureLegsCore;
			if (scopedProxiesByScope[moduleName]) {
				if (scopedProxiesByScope[moduleName][injectId]) {
					scopedProxiesByScope[moduleName][injectId].scopedProxy.removeScope(scopeName);
				}
			}
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
	static pureLegsCore function injectScopedProxy(recipientObject:Object, injectRule:InjectRuleVO):Boolean {
		var scopedProxyMap:ProxyMap = scopedProxyMaps[injectRule.scopeName];
		if (scopedProxyMap) {
			use namespace pureLegsCore;
			var ijectProxy:Proxy = scopedProxyMap.getProxyById(injectRule.injectClassAndName);
			if (ijectProxy) {
				recipientObject[injectRule.varName] = ijectProxy;
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
	static pureLegsCore function addPendingScopedInjection(scopeName:String, injectClassAndName:String, pendingInject:PendingInject):void {
		use namespace pureLegsCore;
		var scopedProxyMap:ProxyMap = scopedProxyMaps[scopeName];
		if (!scopedProxyMap) {
			initScopedProxyMap(scopeName);
			scopedProxyMap = scopedProxyMaps[scopeName];
		}
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
	//     Scope managment
	//----------------------------------
	
	static pureLegsCore function registerScope(moduleName:String, scopeName:String, messageSending:Boolean, messageReceiving:Boolean, proxieMapping:Boolean):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceModuleManager_registerScope(moduleName, scopeName, messageSending, messageReceiving, proxieMapping));
		}
		
		// create dictionary for scope permisions by moduleName
		if (!scopePermissionsRegistry[moduleName]) {
			scopePermissionsRegistry[moduleName] = new Dictionary();
		}
		if (!scopePermissionsRegistry[moduleName][scopeName]) {
			scopePermissionsRegistry[moduleName][scopeName] = new ScopePermissionData();
		}
		
		var scopePermission:ScopePermissionData = scopePermissionsRegistry[moduleName][scopeName];
		
		// set values
		scopePermission.messageSending = messageSending;
		scopePermission.messageReceiving = messageReceiving;
		scopePermission.proxieMapping = proxieMapping;
	}
	
	static pureLegsCore function unregisterScope(moduleName:String, scopeName:String):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceModuleManager_unregisterScope(moduleName, scopeName));
		}
		
		// remove permision data for scope if exists
		if (scopePermissionsRegistry[moduleName]) {
			if (scopePermissionsRegistry[moduleName][scopeName]) {
				delete scopePermissionsRegistry[moduleName][scopeName];
			}
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
		var moduleCount:int = allModules.length
		for (var i:int; i < moduleCount; i++) {
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
	
	/////////////////
	// mvcExpressLive
	static public function listMappedProcesses(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return (moduleRegistry[moduleName] as ModuleBase).listMappedProcesses();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}	
	/////////////////
	

}
}

import org.mvcexpress.mvc.Proxy;

class ScopedProxyData {
	public var scopedProxy:Proxy;
	public var scopeName:String;

	public var injectClass:Class;
	public var name:String;
	
	public var injectId:String;
}

class ScopePermissionData {
	public var messageSending:Boolean;
	public var messageReceiving:Boolean;
	public var proxieMapping:Boolean;
}
