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
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ProxyMap {
	
	/** */
	private var injectClassRegistry:Dictionary = new Dictionary();
	
	/** */
	private var classInjectRules:Dictionary = new Dictionary();
	
	/** dictionary of Vector.<PendingInject>. it holds array of pending data with objects(proxies, commands, mediators) that has pending injections, needed injection spefified by dictionary key.  */
	private var pendingInjectionsRegistry:Dictionary = new Dictionary();
	
	/** Communication object for sending messages*/
	private var messenger:Messenger;
	
	public function ProxyMap(messenger:Messenger) {
		this.messenger = messenger;
	}
	
	/**
	 * Maps praxy object to injectClass and name.
	 * @param	proxyObject	Proxy instance to use for injection.
	 * @param	injectClass	Optional class to use for injection, if null proxyObject class is used. It is helpfull if you want to map proxy interface or subclass.
	 * @param	name		Optional name if you need more then one proxy instance of same class.
	 */
	public function map(proxyObject:Proxy, injectClass:Class = null, name:String = ""):void {
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("+ ProxyMap.map > proxyObject : " + proxyObject + ", injectClass : " + injectClass + ", name : " + name);
			}
		}
		
		var proxyClass:Class = Object(proxyObject).constructor;
		
		if (!injectClass) {
			injectClass = proxyClass;
		}
		var className:String = getQualifiedClassName(injectClass);
		if (!injectClassRegistry[className + name]) {
			use namespace pureLegsCore;
			proxyObject.messenger = messenger;
			var isAllInjected:Boolean = injectStuff(proxyObject, proxyClass);
			injectClassRegistry[className + name] = proxyObject;
			if (pendingInjectionsRegistry[className + name]) {
				injectPendingStuff(className + name, proxyObject);
			}
			if (isAllInjected) {
				proxyObject.register();
			}
		} else {
			throw Error("Proxy object class is already mapped.[injectClass:" + className + " name:" + name + "]");
		}
	}
	
	/**
	 * Removes proxy maped for injection by injectClass and name.
	 *  If mapping does not exists - it will fail silently.
	 * @param	injectClass	class previously mapped for injection
	 * @param	name		name added to class, that was previously mapped for injection
	 */
	public function unmap(injectClass:Class, name:String = ""):void {
		CONFIG::debug {
			if (MvcExpress.debugFunction != null) {
				MvcExpress.debugFunction("- ProxyMap.unmap > injectClass : " + injectClass + ", name : " + name);
			}
		}
		
		var className:String = getQualifiedClassName(injectClass);
		use namespace pureLegsCore;
		(injectClassRegistry[className + name] as Proxy).remove();
		delete injectClassRegistry[className + name];
	}
	
	/**
	 * Dispose of proxyMap
	 * @private
	 */
	pureLegsCore function dispose():void {
		// TODO : decide what to do with proxies. It could be dangerous to remove proxies if they are maped in couple of modules.
		for each (var proxyObject:Proxy in injectClassRegistry) {
			use namespace pureLegsCore;
			proxyObject.remove();
		}
		injectClassRegistry = null;
		classInjectRules = null;
		messenger = null;
	}
	
	// TODO : consider making this function public...
	/**
	 * Finds inject points and injects dependiencies.
	 * tempValue and tempPclass defines injection that will be done for current object only.
	 * @private
	 */
	pureLegsCore function injectStuff(object:Object, signatureClass:Class, tempValue:Object = null, tempClass:Class = null):Boolean {
		use namespace pureLegsCore;
		var isAllInjected:Boolean = true;
		
		// deal with temporal injection. (it is used only for this injection)
		var tempClassName:String;
		if (tempValue) {
			if (tempClass) {
				tempClassName = getQualifiedClassName(tempClass);
				if (!injectClassRegistry[tempClassName]) {
					injectClassRegistry[tempClassName] = tempValue;
				} else {
					throw Error("Temp config sholud not be maped... it was ment to be used by framework for mediator view object only.");
				}
			}
		}
		
		// get class injection rules. (cashing is used.)
		var rules:Vector.<InjectRuleVO> = classInjectRules[signatureClass];
		if (!rules) {
			////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////
			// TODO : TEST inline function .. ( Putting inline function here ... makes commands slower.. WHY!!!)
			rules = getInjectRules(signatureClass);
			classInjectRules[signatureClass] = rules;
				///////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////
		}
		
		// injects all dependencies using rules.
		for (var i:int = 0; i < rules.length; i++) {
			var injectObject:Object = injectClassRegistry[rules[i].injectClassAndName];
			if (injectObject) {
				object[rules[i].varName] = injectObject
			} else {
				isAllInjected = false;
				if (MvcExpress.pendingInjectsTimeOut && !(object is Command)) {
					CONFIG::debug {
						if (MvcExpress.debugFunction != null) {
							// TODO: add option to ignore this warning.
							MvcExpress.debugFunction("WARNING: Pending injection. Inject object is not found for class with id:" + rules[i].injectClassAndName + "(needed in " + object + ")");
						}
					}
					if (!pendingInjectionsRegistry[rules[i].injectClassAndName]) {
						pendingInjectionsRegistry[rules[i].injectClassAndName] = new Vector.<PendingInject>();
					}
					pendingInjectionsRegistry[rules[i].injectClassAndName].push(new PendingInject(rules[i].injectClassAndName, object, signatureClass, MvcExpress.pendingInjectsTimeOut));
					object.pendingInjections++;
				} else {
					throw Error("Inject object is not found for class with id:" + rules[i].injectClassAndName + "(needed in " + object + ")");
				}
			}
		}
		
		// dispose temporal injection if it was used.
		if (tempClassName) {
			delete injectClassRegistry[tempClassName];
		}
		
		return isAllInjected;
	}
	
	private function injectPendingStuff(injectClassAndName:String, injectee:Object):void {
		use namespace pureLegsCore;
		var pendingInjects:Vector.<PendingInject> = pendingInjectionsRegistry[injectClassAndName];
		for (var i:int = 0; i < pendingInjects.length; i++) {
			pendingInjects[i].stopTimer();
			// get rules. (by now rules for this class must be created.)
			var rules:Vector.<InjectRuleVO> = classInjectRules[pendingInjects[i].signatureClass];
			var pendingInject:Object = pendingInjects[i].pendingObject
			for (var j:int = 0; j < rules.length; j++) {
				if (rules[j].injectClassAndName == injectClassAndName) {
					// satisfy missing injection.
					pendingInject[rules[j].varName] = injectee;
					// resolve object;
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
		
		pendingInjectionsRegistry[injectClassAndName]
	}
	
	/**
	 * finds and cashes class injection point rules.
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
	 * @param	injectClass	Optional class to use for injection, if null proxyObject class is used. It is helpfull if you want to map proxy interface or subclass.
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
		if (injectClassRegistry[className + name]) {
			retVal = true;
		}
		return retVal;
	}
	
	/**
	 * Returns text of all mapped proxy objects, and keys they are mapped to.
	 * @return		Text with all mapped proxies.
	 */
	public function listMappings():String {
		var retVal:String = "";
		retVal = "====================== ProxyMap Mappings: ======================\n";
		for (var key:Object in injectClassRegistry) {
			retVal += "PROXY OBJECT:'" + injectClassRegistry[key] + "'\t\t\t(MAPPED TO:" + key + ")\n";
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
		throw Error("Pinding inject object is not resolved in " + pendingInjectTime / 1000 + " second for class with id:" + injectClassAndName + "(needed in " + pendingObject + ")");
	}
}
