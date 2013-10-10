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
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 *
 * @version 2.0.beta2
 */
public class MediatorMap implements IMediatorMap {

	// name of the module MediatorMap is working for.
	protected var moduleName:String;

	// for internal use.
	protected var proxyMap:ProxyMap;

	// for internal use.
	protected var messenger:Messenger;

	// stores all mediator classes using view class(mediator must mediate) as a key.
	protected var mediatorMappingRegistry:Dictionary = new Dictionary(); //* of Dictionary of Class) by Class */

	// stores all mediator is sequence they were mapped.
	protected var mediatorMapOrderRegistry:Dictionary = new Dictionary(); //* of Vector.<Class> by Class */

	// stores all mediators using use view object(mediator is mediating) as a key.
	protected var mediatorRegistry:Dictionary = new Dictionary(); //* of Vector.<Mediator> by Object */

	/** CONSTRUCTOR */
	public function MediatorMap($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap) {
		moduleName = $moduleName;
		messenger = $messenger;
		proxyMap = $proxyMap;
	}

	//----------------------------------
	//     set up of mediators
	//----------------------------------

	/**
	 * Maps mediator classes to view class.
	 * @param    viewClass        view class that has to be mediated by mediator class then mediate() is called on the view object.
	 * @param    mediatorClass    mediator class that will be instantiated then viewClass object is passed to mediate() function.
	 * @param    injectClass        inject mediator as this class.
	 * @param    restClassPairs        rest or mediatorClass and injectClass pairs if you want your view mediated by more then one mediator.
	 */
	public function map(viewClass:Class, mediatorClass:Class, injectClass:Class = null, ...restClassPairs:Array):void {
		// debug this action
		while (mediatorClass) {

			CONFIG::debug {
				use namespace pureLegsCore;

				MvcExpress.debug(new TraceMediatorMap_map(moduleName, viewClass, mediatorClass, injectClass));
				// check if mediatorClass is subclass of Mediator class
				if (!checkClassSuperclass(mediatorClass, "mvcexpress.mvc::Mediator")) {
					throw Error("mediatorClass:" + mediatorClass + " you are trying to map is not extended from 'mvcexpress.mvc::Mediator' class.");
				}

				// var check if extension is supported by this module.
				var extensionId:int = ExtensionManager.getExtensionId(mediatorClass);
				if (SUPPORTED_EXTENSIONS[extensionId] == null) {
					throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(mediatorClass) + " extension enabled to use " + mediatorClass + " command.");
				}
			}

			// check if mapping is not created already
			if (mediatorMappingRegistry[viewClass] != null) {
				if (mediatorMappingRegistry[viewClass][mediatorClass] != null) {
					throw Error("Mediator class:" + mediatorClass + " is already mapped with this view class:" + viewClass + "");
				}
			}

			// map mediatorClass to viewClass
			if (mediatorMappingRegistry[viewClass] == null) {
				mediatorMappingRegistry[viewClass] = new Dictionary();
			}

			if (mediatorMapOrderRegistry[viewClass] == null) {
				mediatorMapOrderRegistry[viewClass] = new Vector.<Class>();
			}


			// map injectClass to viewClass and mediatarClass.
			if (!injectClass) {
				injectClass = viewClass;
			}
			mediatorMappingRegistry[viewClass][mediatorClass] = injectClass;
			mediatorMapOrderRegistry[viewClass].push(mediatorClass);

			// set multi Mediators.
			if (restClassPairs) {
				if (restClassPairs.length) {
					mediatorClass = restClassPairs.shift();
					if (restClassPairs.length) {
						injectClass = restClassPairs.shift();
					} else {
						injectClass = null;
					}
				} else {
					mediatorClass = null;
				}
			}
		}
	}

	/**
	 * Unmaps all or specific mediator class from given view class.
	 * If view is not mapped - it will fail silently.
	 * @param    viewClass    view class to remove mapped mediator class from.
	 * @param    mediatorClass    optional parameter if you want to unmap specific mediator. If this is not set - all mediators will be unmapped.
	 */
	public function unmap(viewClass:Class, mediatorClass:Class = null):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceMediatorMap_unmap(moduleName, viewClass, mediatorClass));
		}
		// clear mapping
		if (mediatorMappingRegistry[viewClass] != null) {
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
	 * Mediates provided viewObject with all mapped mediator.
	 * Automatically instantiates mediator class(es)(if mapped), handles all injections(including view object injection), and calls onRegister function.
	 * Throws error if no mediator classes are mapped to viewObject class.
	 * @param    viewObject    view object to mediate.
	 */
	public function mediate(viewObject:Object):void {
		use namespace pureLegsCore;

		if (mediatorRegistry[viewObject]) {
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

				var mediatorClass:Class = mediators[i];
				var injectClass:Class = mappedMediators[mediatorClass];


				// get mapped mediator class.

				CONFIG::debug {
					// Allows Mediator to be constructed. (removed from release build to save some performance.)
					Mediator.canConstruct = true;
				}

				// create mediator.
				var mediator:Mediator = new mediatorClass();

				// debug this action
				CONFIG::debug {
					MvcExpress.debug(new TraceMediatorMap_mediate(moduleName, viewObject, mediator, viewClass, mediatorClass, getQualifiedClassName(mediatorClass)));
				}

				CONFIG::debug {
					// Block Mediator construction.
					Mediator.canConstruct = false;
				}
				if (prepareMediator(mediator, mediatorClass, viewObject, injectClass)) {
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
	protected function prepareMediator(mediator:Mediator, mediatorClass:Class, viewObject:Object, injectClass:Class):Boolean {
		use namespace pureLegsCore;

		var retVal:Boolean;

		mediator.moduleName = moduleName;
		mediator.messenger = messenger;
		mediator.proxyMap = proxyMap;
		mediator.mediatorMap = this;

		retVal = proxyMap.injectStuff(mediator, mediatorClass, viewObject, injectClass);

		if (mediatorRegistry[viewObject] == null) {
			mediatorRegistry[viewObject] = new Vector.<Mediator>;
		}
		mediatorRegistry[viewObject].push(mediator);

		return retVal;
	}

	/**
	 * Mediates viewObject with specified mediator class.                                                                                                    <br>
	 * This function will mediate your view without mapping view class to mediator class.                                                                    <br>
	 * It is usually better practice to use 2 step mediation(map() then mediate()) instead of this function. But sometimes it is not possible/useful.
	 * @param    viewObject        view object to mediate.
	 * @param    mediatorClass    mediator class that will be instantiated and used to mediate view object
	 * @param    injectClass        inject mediator as this class.
	 */
	public function mediateWith(viewObject:Object, mediatorClass:Class, injectClass:Class = null):void {
		use namespace pureLegsCore;

		if (mediatorRegistry[viewObject]) {
			var mediators:Vector.<Mediator> = mediatorRegistry[viewObject];
			for (var i:int = 0; i < mediators.length; i++) {
				if ((mediators[i] as Object).constructor == mediatorClass) {
					throw Error("This view object is already mediated by " + mediators[i]);
				}
			}
		}

		CONFIG::debug {
			// check if mediatorClass is subclass of Mediator class
			if (!checkClassSuperclass(mediatorClass, "mvcexpress.mvc::Mediator")) {
				throw Error("mediatorClass:" + mediatorClass + " you are trying to use is not extended from 'mvcexpress.mvc::Mediator' class.");
			}

			// var check if extension is supported by this module.
			var extensionId:int = ExtensionManager.getExtensionId(mediatorClass);
			if (SUPPORTED_EXTENSIONS[extensionId] == null) {
				throw Error("This extension is not supported by current module. You need " + ExtensionManager.getExtensionName(mediatorClass) + " extension enabled to use " + mediatorClass + " command.");
			}
		}

		CONFIG::debug {
			// Allows Mediator to be constructed. (removed from release build to save some performance.)
			Mediator.canConstruct = true;
		}

		// create mediator.
		var mediator:Mediator = new mediatorClass();

		var viewClass:Class = viewObject.constructor as Class;
		// if '.constructor' fail to get class - do it using class name. (.constructor is faster but might fail with some object.)
		if (!viewClass) {
			viewClass = Class(getDefinitionByName(getQualifiedClassName(viewObject)));
		}

		// if injectClass is not provided - use view class for injection.
		if (!injectClass) {
			injectClass = viewClass;
		}

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceMediatorMap_mediate(moduleName, viewObject, mediator, viewClass, mediatorClass, getQualifiedClassName(mediatorClass)));
		}

		CONFIG::debug {
			// Block Mediator construction.
			Mediator.canConstruct = false;
		}

		if (prepareMediator(mediator, mediatorClass, viewObject, injectClass)) {
			mediator.register();
		}

	}

	/**
	 * Remove mediation of view object by all or specific mediators.                                                                                        <br>
	 * If any mediator is mediating this viewObject - it calls onRemove mediator function, automatically removes all message handlers, all event listeners and dispose it.
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
	 * Checks if mediator class is mapped to view class.
	 * @param    viewClass        view class that has to be mediated by mediator class then mediate(viewObject) is called.
	 * @param    mediatorClass    Optional Mediator class, if provided will check if viewClass is mapped to this particular mediator class.
	 * @return                    true if view class is already mapped to mediator class.
	 */
	public function isMapped(viewClass:Class, mediatorClass:Class = null):Boolean {
		var retVal:Boolean; // = false;
		if (mediatorMappingRegistry[viewClass] != null) {
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
	 * Checks if view object is mediated.
	 * @param    viewObject        View object to check if it is mediated.
	 * @return     true if view object is mediated.
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
	 * @return        Text with all mapped mediators.
	 */
	public function listMappings():String {
		var retVal:String = "";
		retVal = "==================== MediatorMap Mappings: =====================\n";
		for (var viewClass:Object in mediatorMappingRegistry) {
			retVal += "VIEW:'" + viewClass + "'\t> MEDIATED BY > " + mediatorMapOrderRegistry[viewClass] + "\n";
		}
		retVal += "================================================================\n";
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

	CONFIG::debug
	pureLegsCore var SUPPORTED_EXTENSIONS:Dictionary;

	CONFIG::debug
	pureLegsCore function setSupportedExtensions(supportedExtensions:Dictionary):void {
		SUPPORTED_EXTENSIONS = supportedExtensions;
	}

}
}