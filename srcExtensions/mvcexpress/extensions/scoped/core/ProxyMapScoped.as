// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.core {
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import mvcexpress.MvcExpress;
import mvcexpress.core.*;
import mvcexpress.core.inject.InjectRuleVO;
import mvcexpress.core.inject.PendingInject;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_injectPending;
import mvcexpress.core.traceObjects.proxyMap.TraceProxyMap_injectStuff;
import mvcexpress.extensions.scoped.core.inject.InjectRuleScopedVO;
import mvcexpress.extensions.scoped.core.traceObjects.TraceProxyMap_scopeMap;
import mvcexpress.extensions.scoped.core.traceObjects.TraceProxyMap_scopeUnmap;
import mvcexpress.extensions.scoped.core.traceObjects.TraceProxyMap_scopedInjectPending;
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
 * @version scoped.2.0.rc4
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
			var isAllInjected:Boolean = initProxy(proxyObject, proxyClass, injectId);
			if (isAllInjected) {
				proxyObject.register();
			}
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
	override pureLegsCore function injectStuff(object:Object, signatureClass:Class, mediatorViewObject:Object = null, mediatorViewInjectClasses:Vector.<Class> = null):Boolean {
		use namespace pureLegsCore;

		var isAllInjected:Boolean = true;

		// deal with temporal injection. (it is used only for this injection, for example - view object for mediator is used this way.)
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
		for (var r:int; r < ruleCount; r++) {

			var injectObject:Object = null;
			var rule:InjectRuleScopedVO = rules[r] as InjectRuleScopedVO;

			var injectId:String = rule.injectId;
			var scopename:String = rule.scopeName;

			if (scopename) {
				if (!ScopeManager.injectScopedProxy(object, rule)) {
					if (MvcExpress.pendingInjectsTimeOut && !(object is Command)) {
						isAllInjected = false;
						//add injection to pending injections.
						// debug this action
						CONFIG::debug {
							MvcExpress.debug(new TraceProxyMap_scopedInjectPending(scopename, moduleName, object, injectObject, rule));
						}

						ScopeManager.addPendingScopedInjection(scopename, injectId, new PendingInject(injectId, object, signatureClass, MvcExpress.pendingInjectsTimeOut));

						object.pendingInjections++;

						//throw Error("Pending scoped injection is not supported yet.. (IN TODO...)");
					} else {
						throw Error("Inject object is not found in scope:" + scopename + " for class with id:" + injectId + "(needed in " + object + ")");
					}
				}
			} else {

				// check if we inject to mediator.
				if (mediatorViewObject) {
					injectObject = mediatorInjectObjectRegistry[injectId];
					if (injectObject == null && !MvcExpress.usePureMediators) {
						injectObject = injectObjectRegistry[injectId];
						// check if this proxy is not restricted for mediators.
						//if (injectObject in mediatorInjectObjectRegistry) {
						// TODO: check performance hit.
						for (var key:String in mediatorInjectObjectRegistry) {
							if (mediatorInjectObjectRegistry[key] == injectObject) {
								var allowedInjectId:String = key;
							}
						}
						if (allowedInjectId) {
							injectObject = null;
							throw Error("You are trying to inject class:" + injectId + " into " + object + ", but mediators allowed to inject this proxy only as:" + allowedInjectId + " class");
						}
						//}
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
						// check if pending injection feature is enabled. (wait for injcetion if it is.)
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
		mapRule.injectId = injectClass + injectName;
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
