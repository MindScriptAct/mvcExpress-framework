// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.core {
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import mvcexpress.MvcExpress;
import mvcexpress.core.*;
import mvcexpress.core.inject.InjectRuleVO;
import mvcexpress.core.inject.PendingInject;
import mvcexpress.core.lazy.LazyProxyVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_injectPending;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_injectStuff;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_scopeMap;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_scopeUnmap;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_scopedInjectPending;
import mvcexpress.extensions.scoped.core.inject.InjectRuleScopedVO;
import mvcexpress.extensions.scoped.modules.ModuleScoped;
import mvcexpress.extensions.scoped.mvc.ProxyScoped;
import mvcexpress.mvc.Command;
import mvcexpress.mvc.PooledCommand;
import mvcexpress.mvc.Proxy;

use namespace pureLegsCore;

/**
 * ProxyMap is responsible for storing proxy objects and handling injection.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version scoped.1.0.beta2
 */
public class ProxyMapScoped extends ProxyMap {


	public function ProxyMapScoped($moduleName:String, $messenger:Messenger) {
		super($moduleName, $messenger);
	}


	//----------------------------------
	//     mapping to scope
	//----------------------------------

	/**
	 * Maps proxy object to the scape with injectClass and name.
	 * @param    scopeName    scope name to map proxy to. Same scope name must be used for injection.
	 * @param    proxyObject    Proxy instance to use for injection.
	 * @param    injectClass    Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param    name        Optional name if you need more then one proxy instance of same class.
	 */
	public function scopeMap(scopeName:String, proxyObject:ProxyScoped, injectClass:Class = null, name:String = ""):void {
		use namespace pureLegsCore;

		//debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxyMap_scopeMap(moduleName, scopeName, proxyObject, injectClass, name));
		}

		// init proxy if needed.
		if (proxyObject.messenger == null) {
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
			//
			initProxy(proxyObject, proxyClass, injectId);
		}

		ScopeManager.scopeMap(moduleName, scopeName, proxyObject, injectClass, name);
	}

	/**
	 * Removes proxy mapped to scope with injectClass and name.
	 *  If mapping does not exists - it will fail silently.
	 * @param    scopeName    class previously mapped for injection
	 * @param    injectClass    class previously mapped for injection
	 * @param    name        name added to class, that was previously mapped for injection
	 */
	public function scopeUnmap(scopeName:String, injectClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxyMap_scopeUnmap(moduleName, scopeName, injectClass, name));
		}

		ScopeManager.scopeUnmap(moduleName, scopeName, injectClass, name);
	}


	/**
	 * Finds inject points and injects dependencies.
	 * tempValue and tempClass defines injection that will be done for current object only.
	 * @private
	 */
	override pureLegsCore function injectStuff(object:Object, signatureClass:Class, tempValue:Object = null, tempClass:Class = null):Boolean {
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
			var rule:InjectRuleScopedVO = rules[i] as InjectRuleScopedVO;
			var scopename:String = rule.scopeName;
			var injectClassAndName:String = rule.injectClassAndName;
			if (scopename) {
				if (!ScopeManager.injectScopedProxy(object, rule)) {
					if (MvcExpress.pendingInjectsTimeOut && !(object is Command)) {
						isAllInjected = false;
						//add injection to pending injections.
						// debug this action
						CONFIG::debug {
							MvcExpress.debug(new TraceProxyMap_scopedInjectPending(scopename, moduleName, object, injectObject, rule));
						}

						ScopeManager.addPendingScopedInjection(scopename, injectClassAndName, new PendingInject(injectClassAndName, object, signatureClass, MvcExpress.pendingInjectsTimeOut));

						object.pendingInjections++;

						//throw Error("Pending scoped injection is not supported yet.. (IN TODO...)");
					} else {
						throw Error("Inject object is not found in scope:" + scopename + " for class with id:" + injectClassAndName + "(needed in " + object + ")");
					}
				}
			} else {
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

	override protected function getInjectRule(args:XMLList, varName:String, injectClass:String):InjectRuleVO {
		var injectName:String = "";
		var scopeName:String = "";
		var argCount:int = args.length();
		for (var k:int = 0; k < argCount; k++) {
			var argKey:String = args[k].@key;
			if (argKey == "name") {
				injectName = args[k].@value;
			} else if (argKey == "scope") {
				scopeName = args[k].@value;
			} else if (argKey == "constName") {
				injectName = getInjectByContName(args[k].@value);
			} else if (argKey == "constScope") {
				scopeName = getInjectByContName(args[k].@value);
			}
		}
		var mapRule:InjectRuleScopedVO = new InjectRuleScopedVO();
		mapRule.varName = varName;
		mapRule.injectClassAndName = injectClass + injectName;
		mapRule.scopeName = scopeName;
		return mapRule;
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	override pureLegsCore function setSupportedExtensions(supportedExtensions:Dictionary):void {
		super.setSupportedExtensions(supportedExtensions);
		if (!SUPPORTED_EXTENSIONS[ModuleScoped.EXTENSION_SCOPED_ID]) {
			throw Error("This extension is not supported by current module. You need " + ModuleScoped.EXTENSION_SCOPED_NAME + " extension enabled.");
		}
	}

}
}
