package mvcexpress.extensions.scoped.core {
import flash.utils.Dictionary;

import mvcexpress.MvcExpress;
import mvcexpress.core.ModuleManager;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.inject.PendingInject;
import mvcexpress.core.messenger.HandlerVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.scoped.core.traceObjects.TraceModuleManager_registerScope;
import mvcexpress.extensions.scoped.core.traceObjects.TraceModuleManager_unregisterScope;
import mvcexpress.extensions.scoped.core.inject.InjectRuleScopedVO;
import mvcexpress.extensions.scoped.modules.ModuleScoped;
import mvcexpress.extensions.scoped.mvc.ProxyScoped;
import mvcexpress.mvc.Proxy;

/**
 * Static class for scope managment.
 * @version scoped.1.0.beta2
 */
public class ScopeManager {

	/* all messengers by scope name */
	static private var scopedMessengers:Dictionary = new Dictionary(); //* of Messenger by String{moduleName} */

	/* all proxies by scope name */
	static private var scopedProxyMaps:Dictionary = new Dictionary(); //* of ProxyMap by String{moduleName} */

	/* all proxies mapped to scope */
	static private var scopedProxiesByScope:Dictionary = new Dictionary(); //* of Dictionary(of ProxyMap by Proxy) by String{moduleName} */

	/* all module permission data's by modelName and scopeName */
	static private var scopePermissionsRegistry:Dictionary = new Dictionary(); 	//* of Dictionary (of ScopePermissionData by scopeName String) by moduleName String */


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
				throw Error("Module with name:" + moduleName + " has no permition to send constants to scope:" + scopeName + ". Please use: registerScopeTest() function.");
			}
		}

		// send constants
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
			throw Error("Module with name:" + moduleName + " has no permition to receive constants from scope:" + scopeName + ". Please use: registerScopeTest() function.");
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
	 * @param    handleCommandExecute
	 * @param    scopeName
	 * @param    type
	 * @param    commandClass
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
			throw Error("Module with name:" + moduleName + " has no permition to receive constants and execute commands from scope:" + scopeName + ". Please use: registerScopeTest() function.");
		}

		var scopeMessenger:Messenger = scopedMessengers[scopeName];
		if (!scopeMessenger) {
			use namespace pureLegsCore;

			Messenger.allowInstantiation = true;
			scopeMessenger = new Messenger("$scope_" + scopeName);
			Messenger.allowInstantiation = false;
			scopedMessengers[scopeName] = scopeMessenger;
		}
		return scopeMessenger.addCommandHandler(scopeName + "_^~_" + type, handleCommandExecute, commandClass);
	}

	/**
	 * Unmap command to scoped message.
	 * @param handleCommandExecute
	 * @param scopeName
	 * @param type
	 * @private
	 */
	static pureLegsCore function scopedCommandUnmap(handleCommandExecute:Function, scopeName:String, type:String):void {
		var scopeMessenger:Messenger = scopedMessengers[scopeName];
		if (scopeMessenger) {
			scopeMessenger.removeHandler(scopeName + "_^~_" + type, handleCommandExecute);
		}
	}


	//----------------------------------
	//     proxy scoping
	//----------------------------------

	/**
	 * Map proxy to scope
	 * @param    moduleName
	 * @param    scopeName
	 * @param    proxyObject
	 * @param    injectClass
	 * @param    name
	 * @private
	 */
	static pureLegsCore function scopeMap(moduleName:String, scopeName:String, proxyObject:ProxyScoped, injectClass:Class, name:String):void {

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
		var injectId:String = scopedProxyMap.map(proxyObject, name, injectClass);

		// add scope to proxy so it could send scoped constants.
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
	 * @param    moduleName
	 * @param    scopeName
	 * @param    injectClass
	 * @param    name
	 * @private
	 */
	static pureLegsCore function scopeUnmap(moduleName:String, scopeName:String, injectClass:Class, name:String):void {
		var scopedProxyMap:ProxyMap = scopedProxyMaps[scopeName];
		if (scopedProxyMap) {
			var injectId:String = scopedProxyMap.unmap(injectClass, name);
			// remove scope from proxy, so it would stop sending scoped constants.
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
	 * @param    object
	 * @param    injectRule
	 * @return
	 * @private
	 */
	static pureLegsCore function injectScopedProxy(recipientObject:Object, injectRule:InjectRuleScopedVO):Boolean {
		var scopedProxyMap:ProxyMap = scopedProxyMaps[injectRule.scopeName];
		if (scopedProxyMap) {
			use namespace pureLegsCore;

			var ijectProxy:Proxy = scopedProxyMap.getProxyById(injectRule.injectId);
			if (ijectProxy) {
				recipientObject[injectRule.varName] = ijectProxy;
				return true;
			}
		}
		return false;
	}

	/**
	 * Adds pending scoped injection.
	 * @param    scopeName
	 * @param    injectClassAndName
	 * @param    pendingInject
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
	 * @param    scopeName
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
		var scopedProxyMap:ProxyMap = new ProxyMap("$scope_" + scopeName, scopedMesanger);
		CONFIG::debug {
			// TODO : rethink.
			// enable first 32 extensions for scoped proxy map, as this does not apply to scoped proxies.
			if (!SUPPORTED_EXTENSIONS) {
				SUPPORTED_EXTENSIONS = new Dictionary();
				for (var i:int = 0; i < 32; i++) {
					SUPPORTED_EXTENSIONS[i] = true;
				}
			}
			scopedProxyMap.setSupportedExtensions(SUPPORTED_EXTENSIONS);
		}
		scopedProxyMaps[scopeName] = scopedProxyMap;

	}


	//----------------------------------
	//     Scope managment
	//----------------------------------

	/** @private */
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

	/** @private */
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

	/**
	 * Dispose module scoped.
	 * @param moduleName
	 */
	public static function disposeModule(moduleName:String):void {
		use namespace pureLegsCore;

		var moduleScoped:ModuleScoped = ModuleManager.getModule(moduleName) as ModuleScoped;
		if (moduleScoped) {
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
			delete scopePermissionsRegistry[moduleName];
		} else {
			throw Error("Module with moduleName:" + moduleName + " doesn't exist.");
		}
	}

	// REFACTOR : temp fuction to reset state - needs refactor after scope stuff is removed from here.
	static public function disposeAll():void {
		use namespace pureLegsCore;

		// FIX ME - decide how to implement this..

		for each(var messenger:Messenger in scopedMessengers) {
			messenger.dispose();
		}
		scopedMessengers = new Dictionary();

		for each(var proxyMap:ProxyMap in scopedProxyMaps) {
			proxyMap.dispose();
		}
		scopedProxyMaps = new Dictionary();

		scopedProxiesByScope = new Dictionary();
		scopePermissionsRegistry = new Dictionary();

	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var SUPPORTED_EXTENSIONS:Dictionary;
}
}

import mvcexpress.mvc.Proxy;

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