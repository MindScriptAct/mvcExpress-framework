// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core {
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mvcexpress.MvcExpress;
import mvcexpress.core.interfaces.IMediatorMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.mediatorMap.TraceMediatorMap_map;
import mvcexpress.core.traceObjects.mediatorMap.TraceMediatorMap_mediate;
import mvcexpress.core.traceObjects.mediatorMap.TraceMediatorMap_unmap;
import mvcexpress.core.traceObjects.mediatorMap.TraceMediatorMap_unmediate;
import mvcexpress.mvc.Mediator;
import mvcexpress.utils.checkClassSuperclass;

use namespace pureLegsCore;

/**
 * Handles application mediators.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc4
 */
public class MediatorMap implements IMediatorMap {

	// name of the module MediatorMap is working for.
	protected var moduleName:String;

	// used internally to work with proxies.
	protected var proxyMap:ProxyMap;

	// used internally to work with proxies.
	protected var viewProxyMap:ProxyMapForMediator;

	// used internally for communications
	protected var messenger:Messenger;

	// stores all view inject classes by mediator and view class(mediator must mediate) as a key.
	protected var mediatorMappingRegistry:Dictionary = new Dictionary(); //* of (Dictionary of Vector.<Class>) by Class */

	// stores all mediators in sequence they were mapped.
	protected var mediatorMapOrderRegistry:Dictionary = new Dictionary(); //* of Vector.<Class> by Class */

	// stores all mediators using view object(mediators are mediating) as a key.
	protected var mediatorRegistry:Dictionary = new Dictionary(); //* of Vector.<Mediator> by Object */

	/** CONSTRUCTOR */
	public function MediatorMap($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap) {
		moduleName = $moduleName;
		messenger = $messenger;
		proxyMap = $proxyMap;
		viewProxyMap = new ProxyMapForMediator(proxyMap);
	}

	//----------------------------------
	//     set up
	//----------------------------------

	/**
	 * Maps one or more mediator classes to view class.
	 * @param    viewClass        view class that has to be mediated by mediator class then mediate() is called on the view object.
	 * @param    mediatorClass    mediator class that will be instantiated then viewClass object is passed to mediate() function.
	 * @param    injectClass        inject view into mediator as this class.
	 * @param    restMediatorAndInjectClasses    more mediator classes followed by one ore more view classes for injection in those mediators.
	 */
	public function map(viewClass:Class, mediatorClass:Class, injectClass:Class = null, ...restMediatorAndInjectClasses:Array):void {
		// do until all mediators are handled. (from restMediatorAndInjectClasses Array too..)
		while (mediatorClass) {

			// debug this action
			CONFIG::debug {
				use namespace pureLegsCore;

				MvcExpress.debug(new TraceMediatorMap_map(moduleName, viewClass, mediatorClass, injectClass));
				// check if mediatorClass is subclass of Mediator class
				if (!checkClassSuperclass(mediatorClass, "mvcexpress.mvc::Mediator", true)) {
					throw Error("mediatorClass:" + mediatorClass + " you are trying to map is not extended from 'mvcexpress.mvc::Mediator' class.");
				}

				// check if extension is supported by this module.
				var extensionId:int = ExtensionManager.getExtensionId(mediatorClass);
				if (SUPPORTED_EXTENSIONS[extensionId] == null) {
					throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(mediatorClass) + " extension enabled to use " + mediatorClass + " class.");
				}
			}

			// check if mapping is not created already
			if ((viewClass in mediatorMappingRegistry)) {
				if (mediatorClass in mediatorMappingRegistry[viewClass]) {
					throw Error("Mediator class:" + mediatorClass + " is already mapped with this view class:" + viewClass + "");
				}
			}

			// create mediator mapping holders.
			if (!(viewClass in mediatorMappingRegistry)) {
				mediatorMappingRegistry[viewClass] = new Dictionary();
			}
			if (!(viewClass in mediatorMapOrderRegistry)) {
				mediatorMapOrderRegistry[viewClass] = new Vector.<Class>();
			}

			if (!injectClass) {
				injectClass = viewClass;
			}

			// map injectClass to viewClass and mediatorClass.
			var injectClasses:Vector.<Class> = new <Class>[];
			mediatorMappingRegistry[viewClass][mediatorClass] = injectClasses;
			injectClasses.push(injectClass);
			mediatorMapOrderRegistry[viewClass].push(mediatorClass);

			// set rest of mediatorClass and injectClass pair classes if more then one mediator is being mapped.

			var nextMediatorFound:Boolean = false;
			while (restMediatorAndInjectClasses.length && !nextMediatorFound) {

				var nextClass:Object = restMediatorAndInjectClasses.shift();

				CONFIG::debug {
					if (!(nextClass is Class)) {
						throw Error("Only Class objects can be provided then mapping views and mediators.");
					}
				}

				// check if next class is mediator class or another view inject class.
				if (checkClassSuperclass(nextClass as Class, "mvcexpress.mvc::Mediator")) {
					// mediator class found!
					nextMediatorFound = true;
					mediatorClass = nextClass as Class;
					if (restMediatorAndInjectClasses.length) {
						injectClass = restMediatorAndInjectClasses.shift();
					} else {
						injectClass = null;
					}
				} else {
					// another view class found - add it to the list.
					injectClasses.push(nextClass);
				}
			}
			if (!nextMediatorFound) {
				mediatorClass = null;
			}
		}
	}

	/**
	 * Unmaps all or specific mediator class from mediating given view class.
	 * If view is not mapped - it will fail silently.
	 * @param    viewClass    view class to remove mapped mediator class from.
	 * @param    mediatorClass    optional parameter if you want to unmap specific mediator. If this is not set - all mediators mediating view class will be unmapped.
	 */
	public function unmap(viewClass:Class, mediatorClass:Class = null):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceMediatorMap_unmap(moduleName, viewClass, mediatorClass));
		}
		// clear mapping
		if (viewClass in mediatorMappingRegistry) {
			if (mediatorClass) {

				var mediators:Vector.<Class> = mediatorMapOrderRegistry[viewClass];
				for (var i:int = 0; i < mediators.length; i++) {
					if (mediators[i] == mediatorClass) {
						mediators.splice(i, 1);
						break;
					}
				}
				//
				if (mediators.length > 0) {
					delete mediatorMappingRegistry[viewClass][mediatorClass];
				} else {
					delete mediatorMappingRegistry[viewClass];
					delete mediatorMapOrderRegistry[viewClass];
				}
			} else {
				delete mediatorMappingRegistry[viewClass];
				delete mediatorMapOrderRegistry[viewClass];
			}
		}
	}

	//----------------------------------
	//     mediating
	//----------------------------------

	/**
	 * @inheritDoc
	 * Mediates provided viewObject by all mapped mediator classes.
	 * Automatically instantiates mediator class(es), handles all injections(including view object injection), and calls onRegister function.            <p>
	 * Throws error if no mediator classes are mapped to viewObject class.                                                                                </p>
	 * @param    viewObject    view object to mediate.
	 */
	public function mediate(viewObject:Object):void {
		use namespace pureLegsCore;

		if (viewObject in mediatorRegistry) {
			throw Error("This view object is already mediated by " + mediatorRegistry[viewObject]);
		}

		var viewClass:Class = viewObject.constructor as Class;
		// if '.constructor' fail to get class - do it using class name. (.constructor is faster but might fail with some object.)
		if (!viewClass) {
			viewClass = getDefinitionByName(getQualifiedClassName(viewObject)) as Class;
		}

		var mediators:Vector.<Class> = mediatorMapOrderRegistry[viewClass];
		if (mediators) {

			var mappedMediators:Dictionary = mediatorMappingRegistry[viewClass];
			for (var i:int = 0; i < mediators.length; i++) {

				// get mapped mediator class.
				var mediatorClass:Class = mediators[i];
				var injectClasses:Vector.<Class> = mappedMediators[mediatorClass];

				CONFIG::debug {
					// Allows Mediator to be constructed. (removed from release build to save some performance.)
					Mediator.canConstruct = true;
				}

				// create mediator.
				var mediator:Mediator = new mediatorClass();

				CONFIG::debug {
					// debug this action
					MvcExpress.debug(new TraceMediatorMap_mediate(moduleName, viewObject, mediator, viewClass, mediatorClass, getQualifiedClassName(mediatorClass)));
					// Block Mediator construction.
					Mediator.canConstruct = false;
				}

				if (prepareMediator(mediator, mediatorClass, viewObject, injectClasses)) {
					mediator.register();
				}
			}
		} else {
			throw Error("View object" + viewObject + " class is not mapped with any mediator class. use mediatorMap.map()");
		}
	}

	/**
	 * Prepares mediator for work.
	 * @param mediator        mediator object.
	 * @param mediatorClass    mediator class.
	 * @param viewObject    view object.
	 * @param injectClass    view inject class.
	 * @return    returns true if all dependencies are injected.
	 * @private
	 */
	protected function prepareMediator(mediator:Mediator, mediatorClass:Class, viewObject:Object, injectClasses:Vector.<Class> = null):Boolean {
		use namespace pureLegsCore;

		var retVal:Boolean;

		mediator.moduleName = moduleName;
		mediator.messenger = messenger;
		mediator.proxyMap = viewProxyMap;
		mediator.mediatorMap = this;

		retVal = proxyMap.injectStuff(mediator, mediatorClass, viewObject, injectClasses);

		if (!(viewObject in mediatorRegistry)) {
			mediatorRegistry[viewObject] = new Vector.<Mediator>;
		}
		mediatorRegistry[viewObject].push(mediator);

		return retVal;
	}

	/**
	 * @inheritDoc
	 * Mediates viewObject with specified mediator class.                                                                                                    <p>
	 * This function will mediate your view without mapping view class to mediator class.
	 * It is usually better practice to use 2 step mediation(map() then mediate()) instead of this function. But sometimes it is not possible/useful.        </p>
	 * @param    viewObject        view object to mediate.
	 * @param    mediatorClass    mediator class that will be instantiated and used to mediate view object
	 * @param    injectClass        inject mediator as this class.
	 * @param    restMediatorAndInjectClasses        Sequence of mediotor classes followed by one and more inject classes, to those mediators.
	 */
	public function mediateWith(viewObject:Object, mediatorClass:Class, injectClass:Class = null, ...restMediatorAndInjectClasses:Array):void {
		use namespace pureLegsCore;

		// get view object view class.
		var viewClass:Class = viewObject.constructor as Class;
		// if '.constructor' fail to get class - do it using class name. (.constructor is faster but might fail with some object.)
		if (!viewClass) {
			viewClass = Class(getDefinitionByName(getQualifiedClassName(viewObject)));
		}

		// do until all mediators are handled. (from restMediatorAndInjectClasses Array too..)
		while (mediatorClass) {

			// check if view object is not already mediated.
			if (viewObject in mediatorRegistry) {
				var mediators:Vector.<Mediator> = mediatorRegistry[viewObject];
				for (var i:int = 0; i < mediators.length; i++) {
					if ((mediators[i] as Object).constructor == mediatorClass) {
						throw Error("This view object is already mediated by " + mediators[i]);
					}
				}
			}

			CONFIG::debug {
				// check if mediatorClass is subclass of Mediator class
				if (!checkClassSuperclass(mediatorClass, "mvcexpress.mvc::Mediator", true)) {
					throw Error("mediatorClass:" + mediatorClass + " you are trying to use is not extended from 'mvcexpress.mvc::Mediator' class.");
				}

				// var check if mediator is supported by this module.
				var extensionId:int = ExtensionManager.getExtensionId(mediatorClass);
				if (SUPPORTED_EXTENSIONS[extensionId] == null) {
					throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(mediatorClass) + " extension enabled to use " + mediatorClass + " command.");
				}

				// Allows Mediator to be constructed. (removed from release build to save some performance.)
				Mediator.canConstruct = true;
			}

			// create mediator.
			var mediator:Mediator = new mediatorClass();

			// if injectClass is not provided - use view class for injection.
			if (!injectClass) {
				injectClass = viewClass;
			}

			CONFIG::debug {
				// debug this action
				MvcExpress.debug(new TraceMediatorMap_mediate(moduleName, viewObject, mediator, viewClass, mediatorClass, getQualifiedClassName(mediatorClass)));

				// Block Mediator construction.
				Mediator.canConstruct = false;
			}

			var injectClasses:Vector.<Class> = new <Class>[];
			injectClasses.push(injectClass);

			// find rest of mediatorClass and injectClass pair classes if more then one mediator is being mapped.
			var nextMediatorClass:Class = null;
			while (restMediatorAndInjectClasses.length && nextMediatorClass == null) {

				var nextClass:Object = restMediatorAndInjectClasses.shift();

				CONFIG::debug {
					if (!(nextClass is Class)) {
						throw Error("Only Class objects can be provided then mapping views and mediators.");
					}
				}

				// check if next class is mediator class or another view inject class.
				if (checkClassSuperclass(nextClass as Class, "mvcexpress.mvc::Mediator")) {

					// mediator class found!
					nextMediatorClass = nextClass as Class;

					if (restMediatorAndInjectClasses.length) {
						injectClass = restMediatorAndInjectClasses.shift();
					} else {
						injectClass = null;
					}
				} else {
					// another view class found - add it to the list.
					injectClasses.push(nextClass);
				}
			}

			// register mediator if everything is injected.
			if (prepareMediator(mediator, mediatorClass, viewObject, injectClasses)) {
				mediator.register();
			}

			if (nextMediatorClass == null) {
				mediatorClass = null;
			} else {
				mediatorClass = nextMediatorClass;
			}
		}
	}

	/**
	 * @inheritDoc
	 * Stops view object mediation by all or specific mediator.                                                                                                        <p>
	 * If any mediator is mediating this viewObject - onRemove mediator function is called, all message handlers and all event listeners(adedd with addListener) are removed automatically, and mediator is disposed. </p>
	 * @param    viewObject    view object witch mediator will be destroyed.
	 * @param    mediatorClass    optional parameter to unmediate specific mediator class. If this not set - all mediators will be removed.
	 */
	public function unmediate(viewObject:Object, mediatorClass:Class = null):void {
		use namespace pureLegsCore;

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceMediatorMap_unmediate(moduleName, viewObject));
		}
		// get object mediator
		var mediators:Vector.<Mediator> = mediatorRegistry[viewObject];
		if (mediators && mediators.length) {
			if (mediatorClass) {
				for (var i:int = 0; i < mediators.length; i++) {
					var mediator:Mediator = mediators[i];
					if ((mediator as Object).constructor == mediatorClass) {
						mediator.remove();
						mediators.splice(i, 1);
						break;
					}
				}
			} else {
				while (mediators.length) {
					mediator = mediators.shift();
					mediator.remove();
				}
				delete mediatorRegistry[viewObject];
			}
		} else {
			throw Error("View object:" + viewObject + " has no mediators created for it.");
		}
	}

	//----------------------------------
	//     Debug
	//----------------------------------

	/**
	 * @inheritDoc
	 * Checks if any or specific mediator class is mapped to view class.
	 * @param    viewClass        view class that has to be mediated by mediator class then mediate(viewObject) is called.
	 * @param    mediatorClass    Optional Mediator class, if provided will check if viewClass is mapped to this specific mediator class.
	 * @return                    true if view class is already mapped to mediator class.
	 */
	public function isMapped(viewClass:Class, mediatorClass:Class = null):Boolean {
		var retVal:Boolean; // = false;
		if (viewClass in mediatorMappingRegistry) {
			if (mediatorClass) {
				if (mediatorMappingRegistry[viewClass][mediatorClass] != null) {
					retVal = true;
				}
			} else {
				retVal = true;
			}
		}
		return retVal;
	}

	/**
	 *
	 * @param    viewObject
	 * @return     true if view object is mediated.
	 */

	/**
	 * @inheritDoc
	 * Checks if view object is mediated by any or specific mediator.
	 * @param viewObject        View object to check if it is mediated.
	 * @param mediatorClass        optional parameter to check if view is mediated by specific mediator.
	 * @return
	 */
	public function isMediated(viewObject:Object, mediatorClass:Class = null):Boolean {
		var retVal:Boolean;// = false;
		var mediators:Vector.<Mediator> = mediatorRegistry[viewObject]
		if (mediators && mediators.length) {
			if (mediatorClass) {
				for (var i:int = 0; i < mediators.length; i++) {
					if ((mediators[i] as Object).constructor == mediatorClass) {
						retVal = true;
						break;
					}
				}
			} else {
				retVal = true;
			}
		}
		return retVal;
		(mediatorRegistry[viewObject] != null);
	}

	/**
	 * Returns String of all view classes that are mapped to mediator classes. (for debugging)
	 * @param       verbose     if set to true, will return readable string, false will return pairs of view class definition and mediator class list(separated by ',') definition separated by '>', all pairs are separated by ';'.
	 * @return        Text with all mapped mediators.
	 */
	public function listMappings(verbose:Boolean = true):String {
		var retVal:String = "";
		if (verbose) {
			retVal = "==================== MediatorMap Mappings: =====================\n";
		}
		for (var viewClass:Object in mediatorMappingRegistry) {
			if (verbose) {
				retVal += "VIEW:'" + viewClass + "'\t> MEDIATED BY > " + mediatorMapOrderRegistry[viewClass] + "\n";
			} else {
				if (retVal) {
					retVal += ";";
				}
				retVal += getQualifiedClassName(viewClass) + ">";
				var mediators:Vector.<Class> = mediatorMapOrderRegistry[viewClass];
				var mediatorCount:int = mediators.length;
				for (var i:int = 0; i < mediatorCount; i++) {
					if (i > 0) {
						retVal += ",";
					}
					retVal += getQualifiedClassName(mediators[i]);
				}
			}
		}
		if (verbose) {
			retVal += "================================================================\n";
		}
		return retVal;
	}


	//----------------------------------
	//     INTERNAL
	//----------------------------------

	/**
	 * Dispose mediatorMap - unmediate all mediated view objects and set all internals to null.
	 * @private
	 */
	pureLegsCore function dispose():void {
		// unmediate all mediated view objects
		for (var viewObject:Object in mediatorRegistry) {
			unmediate(viewObject);
		}
		mediatorRegistry = null;
		//
		proxyMap = null;
		messenger = null;
		mediatorMappingRegistry = null;
		mediatorMapOrderRegistry = null;
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