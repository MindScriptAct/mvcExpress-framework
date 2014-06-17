// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core {
import flash.system.System;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mvcexpress.MvcExpress;
import mvcexpress.core.inject.InjectRuleVO;
import mvcexpress.core.inject.PendingInject;
import mvcexpress.core.interfaces.IProxyMap;
import mvcexpress.core.lazy.LazyProxyVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_injectPending;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_injectStuff;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_lazyMap;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_map;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_unmap;
import mvcexpress.mvc.Command;
import mvcexpress.mvc.Mediator;
import mvcexpress.mvc.PooledCommand;
import mvcexpress.mvc.Proxy;
import mvcexpress.utils.checkClassSuperclass;

use namespace pureLegsCore;

/**
 * ProxyMap is responsible for storing proxy objects and handling injection.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc4
 */
public class ProxyMap implements IProxyMap {

	// name of the module CommandMap is working for.
	protected var moduleName:String;

	// used internally for communications
	protected var messenger:Messenger;

	// used internally for command pool handling.
	protected var commandMap:CommandMap;

	/** stores class QualifiedClassName by class */
	static protected var qualifiedClassNameRegistry:Dictionary = new Dictionary(); //* of String by Class */

	/** dictionary of (Vector of InjectRuleVO), stored by class names. */
	static protected var classInjectRules:Dictionary = new Dictionary(); //* of Vector.<InjectRuleVO> by Class */

	/** all objects ready for injection stored by key. (className + inject name) */
	protected var injectObjectRegistry:Dictionary = new Dictionary(); //* of Proxy by String */

	/** dictionary of (Vector of PendingInject), it holds array of pending data with proxies and mediators that has pending injections,  stored by needed injection key(className + inject name).  */
	protected var pendingInjectionsRegistry:Dictionary = new Dictionary(); //* of Vector.<PendingInject> by String */

	/** dictionary of lazy Proxies, those proxies will be instantiated and mapped on first use. */
	protected var lazyProxyRegistry:Dictionary = new Dictionary(); //* of Vector.<PendingInject> by String */

	/** Dictionary with constants of inject names, used with constName, and constScope. */
	protected var classConstRegistry:Dictionary = new Dictionary();

	// DOIT : document.
	protected var mediatorInjectObjectRegistry:Dictionary = new Dictionary(); //* of Proxy by String */
	protected var mediatorInjectIdRegistry:Dictionary = new Dictionary(); //* of String by String */


	/** CONSTRUCTOR */
	public function ProxyMap($moduleName:String, $messenger:Messenger) {
		moduleName = $moduleName;
		messenger = $messenger;
	}


	//----------------------------------
	//     set up proxies
	//----------------------------------

	/**
	 * Maps proxy object to injectClass and name.
	 * @param    proxyObject    Proxy instance to use for injection.
	 * @param    name        Optional name if you need more then one proxy instance of same class.
	 * @param    injectClass    Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param    mediatorInjectClass    Optional class to use for injection in mediators, if null - injectClass class is used. If  injectClass is null - proxyObject class is used. If 'MvcExpress.usePureMediators' is set to true - proxy can be injected into mediators ONLY if class assigned to this property.
	 * @return    returns inject id. (for debugging reasons only.)
	 */
	public function map(proxyObject:Proxy, name:String = null, injectClass:Class = null, mediatorInjectClass:Class = null):String {
		use namespace pureLegsCore;

		// get proxy class
		var proxyClass:Class = Object(proxyObject).constructor as Class;

		// if injectClass is not provided - proxyClass will be used instead.
		if (!injectClass) {
			injectClass = proxyClass;
		}

		if (name == null) {
			name = "";
		}

		// get inject id
		var className:String = qualifiedClassNameRegistry[injectClass];
		if (!className) {
			className = getQualifiedClassName(injectClass);
			qualifiedClassNameRegistry[injectClass] = className;
		}
		var injectId:String = className + name;

		if (injectId in lazyProxyRegistry) {
			throw Error("Proxy object is already lazy mapped. [injectClass:" + injectClass + " name:" + name + "]");
		}

		if (injectId in injectObjectRegistry) {
			throw Error("Proxy object is already mapped. [injectClass:" + className + " name:" + name + "]");
		}

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxyMap_map(moduleName, proxyObject, injectClass, name));

			// var check if extension is supported by this module.
			var extensionId:int = ExtensionManager.getExtensionId(proxyClass);
			if (SUPPORTED_EXTENSIONS[extensionId] == null) {
				throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(proxyClass) + " extension enabled to use " + proxyClass + " proxy.");
			}
		}

		if (proxyObject.messenger == null) {
			var isAllInjected:Boolean = initProxy(proxyObject, proxyClass, injectId);
		}

		if (!(injectId in injectObjectRegistry)) {
			// store proxy injection for other classes.
			injectObjectRegistry[injectId] = proxyObject;
		} else {
			throw Error("Proxy object class is already mapped.[injectClass:" + className + " name:" + name + "]");
		}
		if (mediatorInjectClass != null) {
			className = qualifiedClassNameRegistry[mediatorInjectClass];
			if (!className) {
				className = getQualifiedClassName(mediatorInjectClass);
				qualifiedClassNameRegistry[mediatorInjectClass] = className;
			}

			var mediatorInjectId:String = className + name;
			if (!(mediatorInjectId in mediatorInjectObjectRegistry)) {
				mediatorInjectObjectRegistry[mediatorInjectId] = proxyObject;
				mediatorInjectIdRegistry[injectId] = mediatorInjectId;

				// handle case of pending injection.
				if (mediatorInjectId in pendingInjectionsRegistry) {
					injectPendingStuff(mediatorInjectId, proxyObject);
				}
			} else {
				throw Error("Proxy object class is already mapped for inject to mediators.[injectClass:" + className + " name:" + name + "]");
			}
		}

		// check if there is no pending injection with this key.
		if (injectId in pendingInjectionsRegistry) {
			injectPendingStuff(injectId, proxyObject);
		}

		// register proxy is all injections are done.
		if (isAllInjected) {
			proxyObject.register();
		}

		return injectId;
	}

	/**
	 * Removes proxy mapped for injection by injectClass and name.
	 *  If mapping does not exists - it will fail silently.
	 * @param    injectClass    class previously mapped for injection
	 * @param    name           name added to class, that was previously mapped for injection
	 * @return   returns inject id. (for debugging reasons only.)
	 */
	public function unmap(injectClass:Class, name:String = null):String {
		use namespace pureLegsCore;

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxyMap_unmap(moduleName, injectClass, name));
		}

		if (name == null) {
			name = "";
		}
		// get inject id
		var className:String = qualifiedClassNameRegistry[injectClass];
		if (!className) {
			className = getQualifiedClassName(injectClass);
			qualifiedClassNameRegistry[injectClass] = className;
		}
		var injectId:String = className + name;

		// remove proxy if it exists.
		if (injectId in injectObjectRegistry) {
			var proxy:Proxy = injectObjectRegistry[injectId] as Proxy;

			// handle dependencies..
			var dependencies:Dictionary = proxy.getDependantCommands();
			for each (var item:Class in dependencies) {
				commandMap.clearCommandPool(item);
			}
			proxy.remove();

			delete injectObjectRegistry[injectId];
		}

		// clear any injection mapping into mediators.
		if (injectId in mediatorInjectIdRegistry) {
			delete mediatorInjectObjectRegistry[mediatorInjectIdRegistry[injectId]];
			delete mediatorInjectIdRegistry[injectId];
		}

		// clear lazy mappings
		if (injectId in lazyProxyRegistry) {
			lazyProxyRegistry[injectId].dispose();
			delete lazyProxyRegistry[injectId];
		}

		return injectId;
	}


	//----------------------------------
	//     Lazy map
	//----------------------------------

	/**
	 * Stores lazy proxy data to be instantiated on first use. Proxy will be instantiated and mapped then requested for the first time.
	 * @param    proxyClass        Class to construct proxy.
	 * @param    name            Optional name if you need more then one proxy instance of same class.
	 * @param    injectClass    Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param    proxyConstructorParams    parameters to pass to proxy constructor. (up to 10 parameters)
	 * @return    returns inject id. (for debugging reasons only.)
	 */
	public function lazyMap(proxyClass:Class, name:String = null, injectClass:Class = null, mediatorInjectClass:Class = null, proxyConstructorParams:Array = null):String {

		if (!injectClass) {
			injectClass = proxyClass;
		}

		if (name == null) {
			name = "";
		}

		// get inject id
		var className:String = qualifiedClassNameRegistry[injectClass];
		if (!className) {
			className = getQualifiedClassName(injectClass);
			qualifiedClassNameRegistry[injectClass] = className;
		}
		var injectId:String = className + name;

		if (injectId in lazyProxyRegistry) {
			throw Error("Proxy class is already lazy mapped. [injectClass:" + className + " name:" + name + "]");
		}
		if (injectId in injectObjectRegistry) {
			throw Error("Proxy object is already mapped. [injectClass:" + className + " name:" + name + "]");
		}

		//debug this action
		CONFIG::debug {
			use namespace pureLegsCore;

			if (!checkClassSuperclass(proxyClass, "mvcexpress.mvc::Proxy")) {
				throw Error("proxyClass:" + proxyClass + " you are trying to lazy map is not extended from 'mvcexpress.mvc::Proxy' class.");
			}
			if (proxyConstructorParams && proxyConstructorParams.length > 10) {
				throw Error("Only up to 10 Proxy parameters are supported. Please refactor some into parameter container objects. [injectClass:" + className + " name:" + name + " proxyParams:" + proxyConstructorParams + "]");
			}

			// var check if extension is supported by this module.
			var extensionId:int = ExtensionManager.getExtensionId(proxyClass);
			if (SUPPORTED_EXTENSIONS[extensionId] == null) {
				throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(proxyClass) + " extension enabled to use " + proxyClass + " proxy.");
			}

			MvcExpress.debug(new TraceProxyMap_lazyMap(moduleName, proxyClass, injectClass, name, proxyConstructorParams));
		}

		var lazyInject:LazyProxyVO = new LazyProxyVO();
		lazyInject.proxyClass = proxyClass;
		lazyInject.injectClass = injectClass;
		lazyInject.injectId = injectId;
		lazyInject.name = name;
		lazyInject.proxyParams = proxyConstructorParams;

		lazyProxyRegistry[injectId] = lazyInject;

		if (mediatorInjectClass) {
			// get inject id
			var mediatorInjectClassName:String = qualifiedClassNameRegistry[mediatorInjectClass];
			if (!mediatorInjectClassName) {
				mediatorInjectClassName = getQualifiedClassName(mediatorInjectClass);
				qualifiedClassNameRegistry[mediatorInjectClass] = mediatorInjectClassName;
			}
			var mediatorInjectId:String = mediatorInjectClassName + name;

			lazyInject.mediatorInjectClass = mediatorInjectClass;
			lazyInject.mediatorInjectId = mediatorInjectId;

			lazyProxyRegistry[mediatorInjectId] = lazyInject;
		}

		// check if this class is not pending.
		if (injectId in pendingInjectionsRegistry) {
			initLazyProxy(injectId);
		}

		return injectId;
	}


	//----------------------------------
	//     get proxy
	//----------------------------------

	/**
	 * @inheritDoc
	 * Get proxy by class. Alternative to injecting proxy automatically.                                                                    <p>
	 *        You might want to get proxy manually then your proxy has dynamic name.
	 *        Also you might want to get proxy manually if your proxy is needed only in rare cases or only for short time.
	 *            (for instance - you need it only in onRegister() function.)                                                                </p>
	 * @param    proxyClass    class of proxy, proxy object is mapped to.
	 * @param    name        Optional name if you need more then one proxy instance of same class.
	 */
	public function getProxy(proxyClass:Class, name:String = null):Proxy {
		if (name == null) {
			name = "";
		}
		var className:String = qualifiedClassNameRegistry[proxyClass];
		if (!className) {
			className = getQualifiedClassName(proxyClass);
			qualifiedClassNameRegistry[proxyClass] = className;
		}
		var injectId:String = className + name;

		// try to get proxy from standard registry.
		var proxyObject:Proxy = injectObjectRegistry[injectId] as Proxy;
		if (!proxyObject) {
			// check lazy proxies.
			if (injectId in lazyProxyRegistry) {
				proxyObject = initLazyProxy(injectId);
			} else {
				throw Error("Proxy object is not mapped. [injectClass:" + className + " name:" + name + "]");
			}
		}
		return proxyObject;
	}


	//----------------------------------
	//     Debug
	//----------------------------------

	/**
	 * Checks if proxy object is mapped using specified class(and optionally name.).                            <p>
	 * Optionally you can check if specific proxyObject is already mapped.                                        </p>
	 *
	 * @param injectClass    Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param name            Optional name if you need more then one proxy instance of same class.
	 * @param proxyObject    Proxy instance, to check if it's mapped.
	 * @return            true if proxy is mapped
	 */
	public function isMapped(injectClass:Class, name:String = null, proxyObject:Proxy = null):Boolean {
		var retVal:Boolean; // = false;
		if (name == null) {
			name = "";
		}
		var className:String = qualifiedClassNameRegistry[injectClass];
		if (!className) {
			className = getQualifiedClassName(injectClass);
			qualifiedClassNameRegistry[injectClass] = className;
		}

		var injectId:String = className + name;

		if (injectId in injectObjectRegistry) {
			if (proxyObject) {
				retVal = (injectObjectRegistry[injectId] == proxyObject);
			} else {
				retVal = true;
			}
		} else {
			// if proxy object is not found, try lazy mapping.
			if (proxyObject == null) {
				if (injectId in lazyProxyRegistry) {
					var lazyProxyData:LazyProxyVO = lazyProxyRegistry[injectId];
					if (lazyProxyData.injectId == injectId) {
						retVal = true;
					}
				}
			}
		}
		return retVal;
	}

	/**
	 * Returns text of all mapped proxy objects, and keys they are mapped to. (for debugging)
	 * @param       verbose     if set to true, will return readable string, false will return pairs of object class name and key it is mapped to separated by '>', all pairs are separated by ';'.
	 * @return        Text string with all mapped proxies.
	 */
	public function listMappings(verbose:Boolean = true):String {
		var retVal:String = "";
		if (verbose) {
			retVal = "====================== ProxyMap Mappings: ======================\n";
		}
		for (var key:Object in injectObjectRegistry) {
			if (verbose) {
				retVal += "PROXY OBJECT:'" + injectObjectRegistry[key] + "'\t\t\t(MAPPED TO:" + key + ")\n";
			} else {
				if (retVal) {
					retVal += ";";
				}
				retVal += getQualifiedClassName(injectObjectRegistry[key]).split("::")[1] + ">" + key;
			}
		}
		if (verbose) {
			retVal += "================================================================\n";
		}
		return retVal;
	}


	//----------------------------------
	//     internal stuff
	//----------------------------------

	/** @private */
	pureLegsCore function setCommandMap(value:CommandMap):void {
		commandMap = value;
	}

	/**
	 * Initiates proxy object.
	 * @param    proxyObject
	 * @private
	 */
	pureLegsCore function initProxy(proxyObject:Proxy, proxyClass:Class, injectId:String):Boolean {
		use namespace pureLegsCore;

		proxyObject.messenger = messenger;
		proxyObject.setProxyMap(this);
		// inject dependencies
		return injectStuff(proxyObject, proxyClass);
	}

	// init lazy proxy
	protected function initLazyProxy(injectId:String):Proxy {

		var lazyProxyData:LazyProxyVO = lazyProxyRegistry[injectId];

		// check if this lazy proxy mapping has second lazy mapping for mediator inject.
		if (lazyProxyData.mediatorInjectId == injectId) {
			// this is lazy proxy mediator inject, clear lazy proxy mapping.
			delete lazyProxyRegistry[lazyProxyData.injectId];
		} else if (lazyProxyData.mediatorInjectId != null) { // check if this lazy proxy has mediator ID mapped.
			// this is lazy proxy inject, with mediator inject also mapped, clear lazy proxy mediator inject mapping.
			delete lazyProxyRegistry[lazyProxyData.mediatorInjectId];
		}

		delete lazyProxyRegistry[injectId];

		var lazyProxy:Proxy;
		if (lazyProxyData.proxyParams) {
			var paramCount:int = lazyProxyData.proxyParams.length;
			if (paramCount == 0) {
				lazyProxy = new lazyProxyData.proxyClass();
			} else if (paramCount == 1) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0]);
			} else if (paramCount == 2) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1]);
			} else if (paramCount == 3) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1], lazyProxyData.proxyParams[2]);
			} else if (paramCount == 4) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1], lazyProxyData.proxyParams[2], lazyProxyData.proxyParams[3]);
			} else if (paramCount == 5) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1], lazyProxyData.proxyParams[2], lazyProxyData.proxyParams[3], lazyProxyData.proxyParams[4]);
			} else if (paramCount == 6) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1], lazyProxyData.proxyParams[2], lazyProxyData.proxyParams[3], lazyProxyData.proxyParams[4], lazyProxyData.proxyParams[5]);
			} else if (paramCount == 7) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1], lazyProxyData.proxyParams[2], lazyProxyData.proxyParams[3], lazyProxyData.proxyParams[4], lazyProxyData.proxyParams[5], lazyProxyData.proxyParams[6]);
			} else if (paramCount == 8) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1], lazyProxyData.proxyParams[2], lazyProxyData.proxyParams[3], lazyProxyData.proxyParams[4], lazyProxyData.proxyParams[5], lazyProxyData.proxyParams[6], lazyProxyData.proxyParams[7]);
			} else if (paramCount == 9) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1], lazyProxyData.proxyParams[2], lazyProxyData.proxyParams[3], lazyProxyData.proxyParams[4], lazyProxyData.proxyParams[5], lazyProxyData.proxyParams[6], lazyProxyData.proxyParams[7], lazyProxyData.proxyParams[8]);
			} else if (paramCount == 10) {
				lazyProxy = new lazyProxyData.proxyClass(lazyProxyData.proxyParams[0], lazyProxyData.proxyParams[1], lazyProxyData.proxyParams[2], lazyProxyData.proxyParams[3], lazyProxyData.proxyParams[4], lazyProxyData.proxyParams[5], lazyProxyData.proxyParams[6], lazyProxyData.proxyParams[7], lazyProxyData.proxyParams[8], lazyProxyData.proxyParams[9]);
			} else {
				throw Error("Lazy proxing is not supported with that many parameters. Cut it down to 10 please. Thanks!  [injectClass:" + lazyProxyData.injectClass + " ,name: " + lazyProxyData.name + "]");
			}
		} else {
			lazyProxy = new lazyProxyData.proxyClass();
		}
		map(lazyProxy, lazyProxyData.name, lazyProxyData.injectClass, lazyProxyData.mediatorInjectClass);

		return lazyProxy;
	}

	/**
	 * Function to get proxy from mediator.
	 * @param proxyClass
	 * @param name
	 * @private
	 * @return
	 */
	pureLegsCore function mediatorGetProxy(proxyClass:Class, name:String = null):Proxy {
		if (name == null) {
			name = "";
		}
		var className:String = qualifiedClassNameRegistry[proxyClass];
		if (!className) {
			className = getQualifiedClassName(proxyClass);
			qualifiedClassNameRegistry[proxyClass] = className;
		}
		var injectId:String = className + name;

		// try to get proxy from mediator registry.
		var proxyObject:Proxy = mediatorInjectObjectRegistry[injectId] as Proxy;
		if (proxyObject == null && !MvcExpress.usePureMediators) {
			proxyObject = injectObjectRegistry[injectId];
		}
		if (!proxyObject) {
			// check lazy proxies.
			if (injectId in lazyProxyRegistry) {
				initLazyProxy(injectId);
				// try to get mediator inject again.
				proxyObject = mediatorInjectObjectRegistry[injectId];
				if (proxyObject == null && !MvcExpress.usePureMediators) {
					proxyObject = injectObjectRegistry[injectId];
				}
			}
		}
		// proxy is not found - throw error.
		if (!proxyObject) {
			if (MvcExpress.usePureMediators) {
				proxyObject = injectObjectRegistry[injectId];
				if (proxyObject) {
					throw Error("You are trying to get proxy class:" + injectId + " from mediator, but mediators are not allowed to inject this proxy. To enable this: set mediatorInjectClass parameter then you map this proxy.");
				} else {
					throw Error("Proxy object is not mapped. [injectClass:" + className + " name:" + name + "]");
				}
			} else {
				throw Error("Proxy object is not mapped. [injectClass:" + className + " name:" + name + "]");
			}
		}
		return proxyObject;
	}

	/**
	 * Function to check if proxy can be received from Mediator.
	 * @param proxyClass
	 * @param name
	 * @return
	 */
	pureLegsCore function mediatorCanGetProxy(proxyClass:Class, name:String = null):Boolean {
		if (name == null) {
			name = "";
		}
		var className:String = qualifiedClassNameRegistry[proxyClass];
		if (!className) {
			className = getQualifiedClassName(proxyClass);
			qualifiedClassNameRegistry[proxyClass] = className;
		}
		var injectId:String = className + name;

		var retVal:Boolean = (injectId in mediatorInjectObjectRegistry);

		// if injection not found, try lazy mapping.
		if (!retVal) {
			if (injectId in lazyProxyRegistry) {
				var lazyProxyData:LazyProxyVO = lazyProxyRegistry[injectId];
				// check if this lazy proxy mapping maps mediator class.
				if (lazyProxyData.mediatorInjectId == injectId) {
					retVal = true;
				}
			}
		}

		return retVal;
	}

	/**
	 * Dispose of proxyMap. Remove all registered proxies and set all internals to null.
	 * @private
	 */
	pureLegsCore function dispose():void {
		use namespace pureLegsCore;

		// Remove all registered proxies
		for each (var proxyObject:Object in injectObjectRegistry) {
			if (proxyObject is Proxy) {
				(proxyObject as Proxy).remove();
			}
		}
		// set internals to null
		injectObjectRegistry = null;

		for (var pendingInjectObject:Object in pendingInjectionsRegistry) {
			var pendingInjects:Vector.<PendingInject> = pendingInjectionsRegistry[pendingInjectObject];
			for (var pi:int = 0; pi < pendingInjects.length; pi++) {
				pendingInjects[pi].dispose();
			}
		}
		pendingInjectionsRegistry = null;
		lazyProxyRegistry = null;
		classConstRegistry = null;

		mediatorInjectObjectRegistry = null;
		mediatorInjectIdRegistry = null;

		commandMap = null;
		messenger = null;
	}

	/**
	 * Finds inject points and injects dependencies.
	 * mediatorObject and mediatorInjectClass defines injection that will be done for current object only.
	 * @private
	 */
	pureLegsCore function injectStuff(object:Object, signatureClass:Class, mediatorViewObject:Object = null, mediatorViewInjectClasses:Vector.<Class> = null):Boolean {
		use namespace pureLegsCore;

		var isAllInjected:Boolean = true;

		// deal with temporal injection. (it is used only for this injection, view object for mediator is used this way.)
		var mediatorInjectClassName:String;
		if (mediatorViewObject) {
			if (mediatorViewInjectClasses) {
				var mediatorInjectClassNames:Vector.<String> = new <String>[];
				for (var i:int = 0; i < mediatorViewInjectClasses.length; i++) {
					var additionalInjectClass:Class = mediatorViewInjectClasses[i];
					mediatorInjectClassName = qualifiedClassNameRegistry[additionalInjectClass];
					if (!mediatorInjectClassName) {
						mediatorInjectClassName = getQualifiedClassName(additionalInjectClass);
						qualifiedClassNameRegistry[additionalInjectClass] = mediatorInjectClassName;
					}
					mediatorInjectObjectRegistry[mediatorInjectClassName] = mediatorViewObject;
					mediatorInjectClassNames.push(mediatorInjectClassName);
				}
			}
		}

		// get class injection rules. (cashing is used.)
		var rules:Vector.<InjectRuleVO> = classInjectRules[signatureClass];
		if (!rules) {
			////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////
			// DOIT: TEST in-line function .. ( Putting in-line function here ... makes commands slower.. WHY!!!)
			rules = getInjectRules(signatureClass);
			classInjectRules[signatureClass] = rules;
			///////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////

		}

		// injects all dependencies using rules.
		var ruleCount:int = rules.length;
		for (var r:int = 0; r < ruleCount; r++) {

			var injectObject:Object = null;
			var rule:InjectRuleVO = rules[r];

			var injectId:String = rule.injectId;

			// check if we inject to mediator.
			if (mediatorViewObject) {
				injectObject = mediatorInjectObjectRegistry[injectId];
				if (injectObject == null && !MvcExpress.usePureMediators) {
					injectObject = injectObjectRegistry[injectId];
					// check if this proxy is not restricted for mediators.
					for (var key:String in mediatorInjectObjectRegistry) {
						if (mediatorInjectObjectRegistry[key] == injectObject) {
							var allowedInjectId:String = key;
						}
					}
					if (allowedInjectId) {
						injectObject = null;
						throw Error("You are trying to inject class:" + injectId + " into " + object + ", but mediators allowed to inject this proxy only as:" + allowedInjectId + " class");
					}
				}
				if (!injectObject) {
					// if injection fails... test for lazy injections
					if (injectId in lazyProxyRegistry) {
						initLazyProxy(injectId);
						injectObject = mediatorInjectObjectRegistry[injectId];
						if (injectObject == null && !MvcExpress.usePureMediators) {
							injectObject = injectObjectRegistry[injectId];
						}
					}
				}
				// proxy is not found
				if (!injectObject) {
					// check if pending injection feature is enabled. (wait for injection if it is.)
					if (MvcExpress.pendingInjectsTimeOut == 0) {
						// throw error.
						injectObject = injectObjectRegistry[injectId];
						if (injectObject) {
							throw Error("You are trying to inject class:" + injectId + " into " + object + ", but mediators are not allowed to inject this proxy. To enable this: set mediatorInjectClass parameter then you map this proxy.");
						} else {
							throw Error("Inject object is not found for class with id:" + injectId + "(needed in " + object + ")");
						}
					}
				}
			} else {
				injectObject = injectObjectRegistry[injectId];
			}

			if (!injectObject) {
				// if local injection fails... test for lazy injections
				if (injectId in lazyProxyRegistry) {
					injectObject = initLazyProxy(injectId);
				} else {
					// remember that not all injections exists
					isAllInjected = false;

					// if pending injection feature is enabled - wait for injection.
					if (MvcExpress.pendingInjectsTimeOut && !(object is Command)) {
						// debug this action
						CONFIG::debug {
							MvcExpress.debug(new TraceProxyMap_injectPending(moduleName, object, injectObject, rule));
						}
						//
						addPendingInjection(injectId, new PendingInject(injectId, object, signatureClass, MvcExpress.pendingInjectsTimeOut));
						object.pendingInjections++;
					} else {
						throw Error("Inject object is not found for class with id:" + injectId + "(needed in " + object + ")");
					}
				}
			}

			if (injectObject) {
				object[rule.varName] = injectObject;
				// debug this action
				CONFIG::debug {
					MvcExpress.debug(new TraceProxyMap_injectStuff(moduleName, object, injectObject, rule));
				}
			}

		}

		////// handle command pooling (register dependencies)
		// check if object is PooledCommand,
		if (object is PooledCommand) {
			var command:PooledCommand = object as PooledCommand;
			//check if it is not pooled already.
			if (!commandMap.isCommandPooled(signatureClass)) {
				// dependencies remembers who is dependant on them.
				ruleCount = rules.length;
				for (r = 0; r < ruleCount; r++) {
					(command[rules[r].varName] as Proxy).registerDependantCommand(signatureClass);
				}
			}
		}

		// dispose mediator injection if it was used.
		if (mediatorInjectClassNames) {
			for (r = 0; r < mediatorInjectClassNames.length; r++) {
				delete mediatorInjectObjectRegistry[mediatorInjectClassNames[r]];
			}
		}

		return isAllInjected;
	}


	/**
	 * Adds pending injection.
	 * @param    injectId
	 * @param    pendingInjection
	 * @private
	 */
	pureLegsCore function addPendingInjection(injectId:String, pendingInjection:PendingInject):void {
		var pendingInjections:Vector.<PendingInject> = pendingInjectionsRegistry[injectId]
		if (!pendingInjections) {
			pendingInjections = new Vector.<PendingInject>();
			pendingInjectionsRegistry[injectId] = pendingInjections;
		}
		pendingInjections[pendingInjections.length] = pendingInjection;
	}

	/**
	 * Handle all pending injections for specified key.
	 * @private
	 */
	protected function injectPendingStuff(injectId:String, injectee:Object):void {
		use namespace pureLegsCore;

		var pendingInjects:Vector.<PendingInject> = pendingInjectionsRegistry[injectId];
		while (pendingInjects.length) {
			//
			var pendingInjection:PendingInject = pendingInjects.pop();

			// get rules. (by now rules for this class must be created.)
			var rules:Vector.<InjectRuleVO> = classInjectRules[pendingInjection.signatureClass];
			var pendingInject:Object = pendingInjection.pendingObject;
			pendingInjection.dispose();
			var ruleCount:int = rules.length;
			for (var j:int = 0; j < ruleCount; j++) {
				if (rules[j].injectId == injectId) {

					// satisfy missing injection.
					pendingInject[rules[j].varName] = injectee;

					// resolve object
					if (pendingInject is Proxy) {
						var proxyObject:Proxy = pendingInject as Proxy;
						proxyObject.pendingInjections--;
						if (proxyObject.pendingInjections == 0) {
							proxyObject.register();
						}
					} else if (pendingInject is Mediator) {
						var mediatorObject:Mediator = pendingInject as Mediator;
						// check if injection is allowed in Mediator.
						if (MvcExpress.usePureMediators) {
							if (!(injectId in mediatorInjectObjectRegistry)) {
								// undo injection..
								pendingInject[rules[j].varName] = null;
								// this injection is not allowed in mediator.
								throw Error("You are trying to inject class:" + injectId + " into " + mediatorObject + ", but mediators are not allowed to inject this proxy. To enable this: set mediatorInjectClass parameter then you map this proxy.");
							}
						}

						mediatorObject.pendingInjections--;
						if (mediatorObject.pendingInjections == 0) {
							mediatorObject.register();
						}
					}
					break;
				}
			}
		}
		//
		delete pendingInjectionsRegistry[injectId];
	}

	/**
	 * Finds and cashes class injection point rules.
	 * @private
	 */
	protected function getInjectRules(signatureClass:Class):Vector.<InjectRuleVO> {
		var retVal:Vector.<InjectRuleVO> = new Vector.<InjectRuleVO>();
		var classDescription:XML = describeType(signatureClass);
		var factoryNodes:XMLList = classDescription.factory.*;
		var nodeCount:int = factoryNodes.length();
		for (var i:int; i < nodeCount; i++) {
			var node:XML = factoryNodes[i];
			var nodeName:String = node.name();
			if (nodeName == "variable" || nodeName == "accessor") {
				var metadataList:XMLList = node.metadata;
				var metadataCount:int = metadataList.length();
				for (var j:int = 0; j < metadataCount; j++) {
					nodeName = metadataList[j].@name;
					if (nodeName == "Inject") {
						retVal[retVal.length] = getInjectRule(metadataList[j].arg, node.@name.toString(), node.@type.toString())
					}
				}
			}
		}
		System.disposeXML(classDescription);
		return retVal;
	}

	/**
	 * Get variable injection rule.
	 * @private
	 */
	protected function getInjectRule(args:XMLList, varName:String, injectClass:String):InjectRuleVO {
		var injectName:String = "";
		var argCount:int = args.length();
		for (var k:int = 0; k < argCount; k++) {
			var argKey:String = args[k].@key;
			if (argKey == "name") {
				injectName = args[k].@value;
			} else if (argKey == "constName") {
				injectName = getInjectByContName(args[k].@value);
			}
		}
		var mapRule:InjectRuleVO = new InjectRuleVO();
		mapRule.varName = varName;
		mapRule.injectId = injectClass + injectName;
		return mapRule;
	}

	/**
	 * Get injection then class is provided as string.
	 * @private
	 */
	[Inline]
	protected function getInjectByContName(constName:String):String {
		if (!(constName in classConstRegistry)) {
			var split:Array = constName.split(".");
			var className:String = split[0];
			var splitLength:int = split.length - 1;
			for (var spliteIndex:int = 1; spliteIndex < splitLength; spliteIndex++) {
				className += "." + split[spliteIndex];
			}
			try {
				var constClass:Class = getDefinitionByName(className) as Class;
				CONFIG::debug {
					if (constClass == null) {
						throw Error("Failed to get class definition by name for [Inject] constName parameter, for class definition:" + className);
					}
					var constNameValue:String = constClass[split[spliteIndex]];
					if (constNameValue == null) {
						throw Error("Failed to get constant value for [Inject] constName parameter, from class:" + constClass + ", with var name:" + split[spliteIndex]);
					}
				}
				classConstRegistry[constName] = constClass[split[spliteIndex]];
				if (!(constName in classConstRegistry)) {
					throw Error("Failed to get constant out of class:" + constClass + " Check constant name: " + split[spliteIndex]);
				}
			} catch (error:Error) {
				throw Error("Failed to get constant out of constName:" + constName + " Can't get class from definition : " + className);
			}
		}
		return classConstRegistry[constName];
	}

	// gets proxy by id directly.
	/** @private */
	pureLegsCore function getProxyById(injectId:String):Proxy {
		return injectObjectRegistry[injectId];
	}


//----------------------------------
//    Extension checking: INTERNAL, DEBUG ONLY.
//----------------------------------

	/** @private */
	CONFIG::debug
	pureLegsCore var SUPPORTED_EXTENSIONS:Dictionary;

	/** @private */
	CONFIG::debug
	pureLegsCore function setSupportedExtensions(supportedExtensions:Dictionary):void {
		SUPPORTED_EXTENSIONS = supportedExtensions;
	}
}
}
