// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.base {
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.base.inject.InjectRuleVO;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.mvc.Command;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.mvc.Proxy;
import org.mvcexpress.MvcExpress;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * ProxyMap is responsible for storing proxy objects and handling injection.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ProxyMap {
	
	/** all objects ready for injection stored by key. (className + inject name) */
	private var injectObjectRegistry:Dictionary = new Dictionary(); /* of Proxy by String */
	
	/** dictionary of (Vector of InjectRuleVO), stored by class names. */
	private var classInjectRules:Dictionary = new Dictionary(); /* of Vector.<InjectRuleVO> by Class */
	
	/** dictionary of (Vector of PendingInject), it holds array of pending data with proxies and mediators that has pending injections,  stored by needed injection key(className + inject name).  */
	private var pendingInjectionsRegistry:Dictionary = new Dictionary(); /* of Vector.<PendingInject> by String */
	
	private var messenger:Messenger;
	
	/** CONSTRUCTOR */
	public function ProxyMap(messenger:Messenger) {
		this.messenger = messenger;
	}
	
	/**
	 * Maps proxy object to injectClass and name.
	 * @param	proxyObject	Proxy instance to use for injection.
	 * @param	injectClass	Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param	name		Optional name if you need more then one proxy instance of same class.
	 */
	public function map(proxyObject:Proxy, injectClass:Class = null, name:String = ""):void {
		// debug this action
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("+ ProxyMap.map > proxyObject : " + proxyObject + ", injectClass : " + injectClass + ", name : " + name);
			}
		}
		
		// get proxy class
		var proxyClass:Class = Object(proxyObject).constructor;
		
		// if injectClass is not provided - proxyClass will be used instead.
		if (!injectClass) {
			injectClass = proxyClass;
		}
		
		var className:String = getQualifiedClassName(injectClass);
		if (!injectObjectRegistry[className + name]) {
			use namespace pureLegsCore;
			proxyObject.messenger = messenger;
			// inject dependencies
			var isAllInjected:Boolean = injectStuff(proxyObject, proxyClass);
			// store proxy injection to other classes.
			injectObjectRegistry[className + name] = proxyObject;
			// check if there is no pending injection with this key.
			if (pendingInjectionsRegistry[className + name]) {
				injectPendingStuff(className + name, proxyObject);
			}
			// register proxy is all injections are done.
			if (isAllInjected) {
				proxyObject.register();
			}
		} else {
			throw Error("Proxy object class is already mapped.[injectClass:" + className + " name:" + name + "]");
		}
	}
	
	/**
	 * Removes proxy mapped for injection by injectClass and name.
	 *  If mapping does not exists - it will fail silently.
	 * @param	injectClass	class previously mapped for injection
	 * @param	name		name added to class, that was previously mapped for injection
	 */
	public function unmap(injectClass:Class, name:String = ""):void {
		// debug this action
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("- ProxyMap.unmap > injectClass : " + injectClass + ", name : " + name);
			}
		}
		// remove proxy if it exists.
		var className:String = getQualifiedClassName(injectClass);
		if (injectObjectRegistry[className + name]) {
			use namespace pureLegsCore;
			(injectObjectRegistry[className + name] as Proxy).remove();
			delete injectObjectRegistry[className + name];
		}
	}
	
	/**
	 * Dispose of proxyMap. Remove all registered proxies and set all internals to null.
	 * @private
	 */
	pureLegsCore function dispose():void {
		// Remove all registered proxies
		for each (var proxyObject:Proxy in injectObjectRegistry) {
			use namespace pureLegsCore;
			proxyObject.remove();
		}
		// set internals to null
		injectObjectRegistry = null;
		classInjectRules = null;
		messenger = null;
	}
	
	// TODO : consider making this function public...
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
				tempClassName = getQualifiedClassName(tempClass);
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
			// TODO : TEST in-line function .. ( Putting in-line function here ... makes commands slower.. WHY!!!)
			rules = getInjectRules(signatureClass);
			classInjectRules[signatureClass] = rules;
				///////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////
		}
		
		// injects all dependencies using rules.
		for (var i:int = 0; i < rules.length; i++) {
			var injectObject:Object = injectObjectRegistry[rules[i].injectClassAndName];
			if (injectObject) {
				object[rules[i].varName] = injectObject
			} else {
				// remember that not all injections exists
				isAllInjected = false;
				
				if (MvcExpress.pendingInjectsTimeOut && !(object is Command)) {
					//add injection to pending injections.
					
					// debug this action
					CONFIG::debug {
						if (MvcExpress.debugFunction != null) {
							// TODO: add option to ignore this warning.
							MvcExpress.debugFunction("WARNING: Pending injection. Inject object is not found for class with id:" + rules[i].injectClassAndName + "(needed in " + object + ")");
						}
					}
					//
					if (!pendingInjectionsRegistry[rules[i].injectClassAndName]) {
						pendingInjectionsRegistry[rules[i].injectClassAndName] = new Vector.<PendingInject>();
					}
					//
					pendingInjectionsRegistry[rules[i].injectClassAndName].push(new PendingInject(rules[i].injectClassAndName, object, signatureClass, MvcExpress.pendingInjectsTimeOut));
					object.pendingInjections++;
				} else {
					throw Error("Inject object is not found for class with id:" + rules[i].injectClassAndName + "(needed in " + object + ")");
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
	 * Handle all pending injections for specified key.
	 */
	private function injectPendingStuff(injectClassAndName:String, injectee:Object):void {
		use namespace pureLegsCore;
		var pendingInjects:Vector.<PendingInject> = pendingInjectionsRegistry[injectClassAndName];
		while (pendingInjects.length) {
			//
			var pendingInjection:PendingInject = pendingInjects.pop();
			pendingInjection.stopTimer();
			
			// get rules. (by now rules for this class must be created.)
			var rules:Vector.<InjectRuleVO> = classInjectRules[pendingInjection.signatureClass];
			var pendingInject:Object = pendingInjection.pendingObject
			for (var j:int = 0; j < rules.length; j++) {
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
		delete pendingInjectionsRegistry[injectClassAndName]
	}
	
	/**
	 * Finds and cashes class injection point rules.
	 */
	private function getInjectRules(signatureClass:Class):Vector.<InjectRuleVO> {
		var retVal:Vector.<InjectRuleVO> = new Vector.<InjectRuleVO>();
		var classDescription:XML = describeType(signatureClass);
		var factoryNodes:XMLList = classDescription.factory.*;
		
		for (var i:int = 0; i < factoryNodes.length(); i++) {
			var node:XML = factoryNodes[i];
			var nodeNome:String = node.name();
			if (nodeNome == "variable" || nodeNome == "accessor") {
				var metadataList:XMLList = node.metadata;
				for (var j:int = 0; j < metadataList.length(); j++) {
					nodeNome = metadataList[j].@name;
					if (nodeNome == "Inject") {
						var injectName:String = "";
						var args:XMLList = metadataList[j].arg;
						if (args[0]) {
							if (args[0].@key == "name") {
								injectName = args[0].@value;
							}
						}
						var mapRule:InjectRuleVO = new InjectRuleVO();
						mapRule.varName = node.@name.toString();
						mapRule.injectClassAndName = node.@type.toString() + injectName;
						retVal.push(mapRule);
					}
				}
			}
		}
		return retVal;
	}
	
	//----------------------------------
	//     Debug
	//----------------------------------
	
	/**
	 * Checks if proxy object is already mapped.
	 * @param	proxyObject	Proxy instance to use for injection.
	 * @param	injectClass	Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param	name		Optional name if you need more then one proxy instance of same class.
	 * @return				true if object is already mapped.
	 */
	public function isMapped(proxyObject:Proxy, injectClass:Class = null, name:String = ""):Boolean {
		var retVal:Boolean = false;
		var proxyClass:Class = Object(proxyObject).constructor;
		if (!injectClass) {
			injectClass = proxyClass;
		}
		var className:String = getQualifiedClassName(injectClass);
		if (injectObjectRegistry[className + name]) {
			retVal = true;
		}
		return retVal;
	}
	
	/**
	 * Returns text of all mapped proxy objects, and keys they are mapped to.
	 * @return		Text string with all mapped proxies.
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

}
}

import flash.utils.clearTimeout;
import flash.utils.setTimeout;

class PendingInject {
	
	/**
	 * Private class to store pending injection data.
	 */
	
	private var injectClassAndName:String;
	public var pendingObject:Object;
	public var signatureClass:Class;
	private var pendingInjectTime:int;
	
	private var timerId:uint;
	
	public function PendingInject(injectClassAndName:String, pendingObject:Object, signatureClass:Class, pendingInjectTime:int) {
		this.pendingInjectTime = pendingInjectTime;
		this.injectClassAndName = injectClassAndName;
		this.pendingObject = pendingObject;
		this.signatureClass = signatureClass;
		// start timer to throw an error of unresolved injection.
		timerId = setTimeout(throwError, pendingInjectTime);
	}
	
	public function stopTimer():void {
		clearTimeout(timerId);
	}
	
	private function throwError():void {
		throw Error("Pending inject object is not resolved in " + pendingInjectTime / 1000 + " second for class with id:" + injectClassAndName + "(needed in " + pendingObject + ")");
	}
}
