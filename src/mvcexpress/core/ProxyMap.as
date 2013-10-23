// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core {
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
 * @version 2.0.rc1
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
	 * @param    injectClass    Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param    name        Optional name if you need more then one proxy instance of same class.
	 * @return    returns inject id. (for debugging reasons only.)
	 */
	public function map(proxyObject:Proxy, injectClass:Class = null, name:String = ""):String {
		use namespace pureLegsCore;

		// get proxy class
		var proxyClass:Class = Object(proxyObject).constructor as Class;

		// if injectClass is not provided - proxyClass will be used instead.
		if (!injectClass) {
			injectClass = proxyClass;
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

		// check if there is no pending injection with this key.
		if (pendingInjectionsRegistry[injectId]) {
			injectPendingStuff(injectId, proxyObject);
		}

		if (!injectObjectRegistry[injectId]) {
			// store proxy injection for other classes.
			injectObjectRegistry[injectId] = proxyObject;
		} else {
			throw Error("Proxy object class is already mapped.[injectClass:" + className + " name:" + name + "]");
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
	public function unmap(injectClass:Class, name:String = ""):String {
		use namespace pureLegsCore;

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxyMap_unmap(moduleName, injectClass, name));
		}
		// get inject id
		var className:String = qualifiedClassNameRegistry[injectClass];
		if (!className) {
			className = getQualifiedClassName(injectClass);
			qualifiedClassNameRegistry[injectClass] = className;
		}
		var injectId:String = className + name;

		// remove proxy if it exists.
		if (injectObjectRegistry[injectId]) {
			var proxy:Proxy = injectObjectRegistry[injectId] as Proxy;

			// handle dependencies..
			var dependencies:Dictionary = proxy.getDependantCommands();
			for each (var item:Class in dependencies) {
				commandMap.clearCommandPool(item);
			}
			proxy.remove();

			delete injectObjectRegistry[injectId];
		}

		return injectId;
	}


	//----------------------------------
	//     Lazy map
	//----------------------------------

	/**
	 * Stores lazy proxy data to be instantiated on first use. Proxy will be instantiated and mapped then requested for the first time.
	 * @param    proxyClass        Class to construct proxy.
	 * @param    injectClass    Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param    name            Optional name if you need more then one proxy instance of same class.
	 * @param    proxyParams    parameters to pass to proxy constructor. (up to 10 parameters)
	 * @return    returns inject id. (for debugging reasons only.)
	 */
	public function lazyMap(proxyClass:Class, injectClass:Class = null, name:String = "", proxyParams:Array = null):String {

		if (!injectClass) {
			injectClass = proxyClass;
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
			if (proxyParams && proxyParams.length > 10) {
				throw Error("Only up to 10 Proxy parameters are supported. Please refactor some into parameter container objects. [injectClass:" + className + " name:" + name + " proxyParams:" + proxyParams + "]");
			}

			// var check if extension is supported by this module.
			var extensionId:int = ExtensionManager.getExtensionId(proxyClass);
			if (SUPPORTED_EXTENSIONS[extensionId] == null) {
				throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(proxyClass) + " extension enabled to use " + proxyClass + " proxy.");
			}

			MvcExpress.debug(new TraceProxyMap_lazyMap(moduleName, proxyClass, injectClass, name, proxyParams));
		}

		var lazyInject:LazyProxyVO = new LazyProxyVO();
		lazyInject.proxyClass = proxyClass;
		lazyInject.injectClass = injectClass;
		lazyInject.name = name;
		lazyInject.proxyParams = proxyParams;

		lazyProxyRegistry[injectId] = lazyInject;

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
	public function getProxy(proxyClass:Class, name:String = ""):Proxy {
		var className:String = qualifiedClassNameRegistry[proxyClass];
		if (!className) {
			className = getQualifiedClassName(proxyClass);
			qualifiedClassNameRegistry[proxyClass] = className;
		}
		var classAndName:String = className + name;
		if (classAndName in injectObjectRegistry) {
			return injectObjectRegistry[classAndName];
		} else {
			throw Error("Proxy object is not mapped. [injectClass:" + className + " name:" + name + "]");
		}
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
	public function isMapped(injectClass:Class, name:String = "", proxyObject:Proxy = null):Boolean {
		var retVal:Boolean; // = false;
		var className:String = qualifiedClassNameRegistry[injectClass];
		if (!className) {
			className = getQualifiedClassName(injectClass);
			qualifiedClassNameRegistry[injectClass] = className;
		}
		if (injectObjectRegistry[className + name]) {
			if (proxyObject) {
				retVal = (injectObjectRegistry[className + name] == proxyObject);
			} else {
				retVal = true;
			}
		}
		return retVal;
	}

	/**
	 * Returns text of all mapped proxy objects, and keys they are mapped to. (for debugging)
	 * @return        Text string with all mapped proxies.
	 */
	public function listMappings():String {
		var retVal:String = "";
		retVal = "====================== ProxyMap Mappings: ======================\n";
		for (var key:Object in injectObjectRegistry) {
			retVal += "PROXY OBJECT:'" + injectObjectRegistry[key] + "'\t\t\t(MAPPED TO:" + key + ")\n";
		}
		retVal += "================================================================\n";
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
		pendingInjectionsRegistry = null;
		lazyProxyRegistry = null;
		classConstRegistry = null;

		commandMap = null;
		messenger = null;
	}

	/**
	 * Finds inject points and injects dependencies.
	 * tempValue and tempClass defines injection that will be done for current object only.
	 * @private
	 */
	pureLegsCore function injectStuff(object:Object, signatureClass:Class, tempValue:Object = null, tempClass:Class = null):Boolean {
		use namespace pureLegsCore;

		var isAllInjected:Boolean = true;

		// deal with temporal injection. (it is used only for this injection, for example - view object for mediator is used this way.)
		var tempClassName:String;
		if (tempValue) {
			if (tempClass) {
				tempClassName = qualifiedClassNameRegistry[tempClass];
				if (!tempClassName) {
					tempClassName = getQualifiedClassName(tempClass);
					qualifiedClassNameRegistry[tempClass] = tempClassName;
				}
				if (!injectObjectRegistry[tempClassName]) {
					injectObjectRegistry[tempClassName] = tempValue;
				} else {
					throw Error("Temp object should not be mapped already... it was meant to be used by framework for mediator view object only.");
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
		for (var i:int; i < ruleCount; i++) {
			var rule:InjectRuleVO = rules[i];
			var injectClassAndName:String = rule.injectClassAndName;
			var injectObject:Object = injectObjectRegistry[injectClassAndName];
			if (injectObject) {
				object[rule.varName] = injectObject;
				// debug this action
				CONFIG::debug {
					MvcExpress.debug(new TraceProxyMap_injectStuff(moduleName, object, injectObject, rule));
				}
			} else {
				// if local injection fails... test for lazy injections
				if (injectClassAndName in lazyProxyRegistry) {
					var lazyProxyData:LazyProxyVO = lazyProxyRegistry[injectClassAndName];
					delete lazyProxyRegistry[injectClassAndName];

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
							throw Error("Lazy proxing is not supported with that many parameters. Cut it douwn please. Thanks!  [injectClass:" + lazyProxyData.injectClass + " ,name: " + lazyProxyData.name + "]");
						}
					} else {
						lazyProxy = new lazyProxyData.proxyClass();
					}
					map(lazyProxy, lazyProxyData.injectClass, lazyProxyData.name);

					i--;

				} else {
					// remember that not all injections exists
					isAllInjected = false;

					if (MvcExpress.pendingInjectsTimeOut && !(object is Command)) {
						//add injection to pending injections.
						// debug this action
						CONFIG::debug {
							MvcExpress.debug(new TraceProxyMap_injectPending(moduleName, object, injectObject, rule));
						}
						//
						addPendingInjection(injectClassAndName, new PendingInject(injectClassAndName, object, signatureClass, MvcExpress.pendingInjectsTimeOut));
						object.pendingInjections++;
					} else {
						throw Error("Inject object is not found for class with id:" + injectClassAndName + "(needed in " + object + ")");
					}
				}
			}
		}

		////// handle command pooling (register dependencies)
		// chekc if object is PooledCommand,
		if (object is PooledCommand) {
			var command:PooledCommand = object as PooledCommand;
			//check if it is not pooled already.
			if (!commandMap.isCommandPooled(signatureClass)) {
				// dependencies remembers who is dependant on them.
				ruleCount = rules.length;
				for (var r:int; r < ruleCount; r++) {
					(command[rules[r].varName] as Proxy).registerDependantCommand(signatureClass);
				}
			}
		}

		// dispose temporal injection if it was used.
		if (tempClassName) {
			delete injectObjectRegistry[tempClassName];
		}
		return isAllInjected;
	}

	/**
	 * Adds pending injection.
	 * @param    injectClassAndName
	 * @param    pendingInjection
	 * @private
	 */
	pureLegsCore function addPendingInjection(injectClassAndName:String, pendingInjection:PendingInject):void {
		var pendingInjections:Vector.<PendingInject> = pendingInjectionsRegistry[injectClassAndName]
		if (!pendingInjections) {
			pendingInjections = new Vector.<PendingInject>();
			pendingInjectionsRegistry[injectClassAndName] = pendingInjections;
		}
		pendingInjections[pendingInjections.length] = pendingInjection;
	}

	/**
	 * Handle all pending injections for specified key.
	 * @private
	 */
	protected function injectPendingStuff(injectClassAndName:String, injectee:Object):void {
		use namespace pureLegsCore;

		var pendingInjects:Vector.<PendingInject> = pendingInjectionsRegistry[injectClassAndName];
		while (pendingInjects.length) {
			//
			var pendingInjection:PendingInject = pendingInjects.pop();
			pendingInjection.stopTimer();

			// get rules. (by now rules for this class must be created.)
			var rules:Vector.<InjectRuleVO> = classInjectRules[pendingInjection.signatureClass];
			var pendingInject:Object = pendingInjection.pendingObject;
			var ruleCount:int = rules.length;
			for (var j:int = 0; j < ruleCount; j++) {
				if (rules[j].injectClassAndName == injectClassAndName) {

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
		delete pendingInjectionsRegistry[injectClassAndName];
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
		mapRule.injectClassAndName = injectClass + injectName;
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
	pureLegsCore function getProxyById(injectClassAndName:String):Proxy {
		return injectObjectRegistry[injectClassAndName];
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
