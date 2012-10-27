// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.core.interfaces.IMediatorMap;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceMediatorMap_map;
import org.mvcexpress.core.traceObjects.TraceMediatorMap_mediate;
import org.mvcexpress.core.traceObjects.TraceMediatorMap_unmap;
import org.mvcexpress.core.traceObjects.TraceMediatorMap_unmediate;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.MvcExpress;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * Handles application mediators.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MediatorMap implements IMediatorMap {
	
	// name of the module MediatorMap is working for.
	private var moduleName:String;
	
	protected var proxyMap:ProxyMap;
	protected var messenger:Messenger;
	
	// stores all mediator classes using view class(mediator must mediate) as a key.
	protected var mediatorClassRegistry:Dictionary = new Dictionary(); /* of Class by Class */
	
	// stores all view inject classes using view class(mediator must mediate) as a key.
	protected var mediatorInjectRegistry:Dictionary = new Dictionary(); /* of Class by Class */
	
	// stores all mediators using use view object(mediator is mediating) as a key.
	protected var mediatorRegistry:Dictionary = new Dictionary(); /* of Mediator by Object */
	
	/** CONSTRUCTOR */
	public function MediatorMap(moduleName:String, messenger:Messenger, proxyMap:ProxyMap) {
		this.moduleName = moduleName;
		this.messenger = messenger;
		this.proxyMap = proxyMap;
	}
	
	/**
	 * Maps mediator class to view class. Only one mediator class can mediate single instance of view class.
	 * @param	viewClass		view class that has to be mediated by mediator class then mediate() is called.
	 * @param	mediatorClass	mediator class that will be instantiated then viewClass object is passed to mediate() function.
	 * @param	injectClass		inject mediator as this class.
	 */
	public function map(viewClass:Class, mediatorClass:Class, injectClass:Class = null):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceMediatorMap_map(MvcTraceActions.MEDIATORMAP_MAP, moduleName, viewClass, mediatorClass));
			// check if mediatorClass is subclass of Mediator class
			if (!checkClassSuperclass(mediatorClass, "org.mvcexpress.mvc::Mediator")) {
				throw Error("mediatorClass:" + mediatorClass + " you are trying to map is not extended from 'org.mvcexpress.mvc::Mediator' class.");
			}
		}
		
		// check if mapping is not created already
		if (mediatorClassRegistry[viewClass]) {
			throw Error("Mediator class:" + mediatorClassRegistry[viewClass] + " is already mapped with this view class:" + viewClass + "");
		}
		
		// map mediatorClass to viewClass
		mediatorClassRegistry[viewClass] = mediatorClass;
		
		// map injectClass to viewClass
		if (!injectClass) {
			injectClass = viewClass;
		}
		mediatorInjectRegistry[viewClass] = injectClass;
	}
	
	/**
	 * Unmaps any mediator class to given view class.
	 * @param	viewClass	view class to remove mapped mediator class from.
	 */
	public function unmap(viewClass:Class):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceMediatorMap_unmap(MvcTraceActions.MEDIATORMAP_UNMAP, moduleName, viewClass));
		}
		// clear mapping
		delete mediatorClassRegistry[viewClass];
		delete mediatorInjectRegistry[viewClass];
	}
	
	/**
	 * Mediates provided viewObject with mapped mediator.
	 * Automatically instantiates mediator class(if mapped), handles all injections(including viewObject), and calls onRegister function.
	 * Throws error if mediator class is not mapped to viewObject class.
	 * @param	viewObject	view object to mediate.
	 */
	public function mediate(viewObject:Object):void {
		
		if (mediatorRegistry[viewObject]) {
			throw Error("This view object is already mediated by " + mediatorRegistry[viewObject]);
		}
		
		use namespace pureLegsCore;
		
		var viewClass:Class = viewObject.constructor as Class;
		// if '.constructor' fail to get class - do it using class name. (.constructor is faster but might fail with some object.)
		if (!viewClass) {
			viewClass = Class(getDefinitionByName(getQualifiedClassName(viewObject)));
		}
		
		var injectClass:Class = mediatorInjectRegistry[viewClass];
		
		// get mapped mediator class.
		var mediatorClass:Class = mediatorClassRegistry[viewClass];
		if (mediatorClass) {
			
			CONFIG::debug {
				// Allows Mediator to be constructed. (removed from release build to save some performance.)
				Mediator.canConstruct = true;
			}
			
			// create mediator.
			var mediator:Mediator = new mediatorClass();
			
			// debug this action
			CONFIG::debug {
				use namespace pureLegsCore;
				MvcExpress.debug(new TraceMediatorMap_mediate(MvcTraceActions.MEDIATORMAP_MEDIATE, moduleName, viewObject, mediator, viewClass, mediatorClass, getQualifiedClassName(mediatorClass)));
			}
			
			CONFIG::debug {
				// Block Mediator construction.
				Mediator.canConstruct = false;
			}
			
			mediator.messenger = messenger;
			mediator.proxyMap = proxyMap;
			mediator.mediatorMap = this;
			
			var isAllInjected:Boolean = proxyMap.injectStuff(mediator, mediatorClass, viewObject, injectClass);
			mediatorRegistry[viewObject] = mediator;
			
			if (isAllInjected) {
				mediator.register();
			}
		} else {
			throw Error("View object" + viewObject + " class is not mapped with any mediator class. use mediatorMap.map()");
		}
	}
	
	/**
	 * Mediates provided viewObject with provided mediator. MvcExpress.feature_mediateWith_enabled must be set to true to use this function.
	 * Use this only if using map() and mediate() functions is not an option. (It might hapen ir cases there you have no controll over objects you are mediating. Like in third party, or legacy code.)
	 * @param	viewObject		view object to mediate.
	 * @param	mediatorClass	mediator class that will be instantiated and used to mediate view object
	 * @param	injectClass		inject mediator as this class.
	 */
	public function mediateWith(viewObject:Object, mediatorClass:Class, injectClass:Class = null):void {
		
		if (mediatorRegistry[viewObject]) {
			throw Error("This view object is already mediated by " + mediatorRegistry[viewObject]);
		}
		
		CONFIG::debug {
			// check if mediatorClass is subclass of Mediator class
			if (!checkClassSuperclass(mediatorClass, "org.mvcexpress.mvc::Mediator")) {
				throw Error("mediatorClass:" + mediatorClass + " you are trying to use is not extended from 'org.mvcexpress.mvc::Mediator' class.");
			}
		}
		
		use namespace pureLegsCore;
		
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
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceMediatorMap_mediate(MvcTraceActions.MEDIATORMAP_MEDIATE, moduleName, viewObject, mediator, viewClass, mediatorClass, getQualifiedClassName(mediatorClass)));
		}
		
		CONFIG::debug {
			// Block Mediator construction.
			Mediator.canConstruct = false;
		}
		
		mediator.messenger = messenger;
		mediator.proxyMap = proxyMap;
		mediator.mediatorMap = this;
		
		var isAllInjected:Boolean = proxyMap.injectStuff(mediator, mediatorClass, viewObject, injectClass);
		mediatorRegistry[viewObject] = mediator;
		
		if (isAllInjected) {
			mediator.register();
		}
	
	}
	
	/**
	 * If any mediator is mediating viewObject: it calls onRemove on that object, automatically removes all handler functions listening for messages from that mediator and deletes it.
	 * @param	viewObject	view object witch mediator will be destroyed.
	 */
	public function unmediate(viewObject:Object):void {
		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceMediatorMap_unmediate(MvcTraceActions.MEDIATORMAP_UNMEDIATE, moduleName, viewObject));
		}
		// get object mediator
		var mediator:Mediator = mediatorRegistry[viewObject];
		if (mediator) {
			mediator.onRemove();
			use namespace pureLegsCore;
			mediator.remove();
			delete mediatorRegistry[viewObject];
		} else {
			throw Error("View object:" + viewObject + " has no mediator created for it.");
		}
	}
	
	/**
	 * Dispose mediatorMap - unmediate all mediated view objects and set all internals to null.
	 * @private
	 */
	pureLegsCore function dispose():void {
		// unmediate all mediated view objects
		for (var viewObject:Object in mediatorRegistry) {
			unmediate(viewObject);
		}
		proxyMap = null;
		messenger = null;
		mediatorClassRegistry = null;
		mediatorInjectRegistry = null;
		mediatorRegistry = null;
	}
	
	//----------------------------------
	//     Debug
	//----------------------------------
	
	/**
	 * Checks if mediator class is mapped to view class.
	 * @param	viewClass		view class that has to be mediated by mediator class then mediate(viewObject) is called.
	 * @param	mediatorClass	Mediator class that will be instantiated then viewClass object is passed to mediate function.
	 * @return					true if view class is already mapped to mediator class.
	 */
	public function isMapped(viewClass:Class, mediatorClass:Class):Boolean {
		var retVal:Boolean = false;
		if (mediatorClassRegistry[viewClass]) {
			if (mediatorClassRegistry[viewClass] == mediatorClass) {
				retVal = true;
			}
		}
		return retVal;
	}
	
	/**
	 * Checks if view object is mediated.
	 * @param	viewObject		View object to check if it is mediated.
	 */
	public function isMediated(viewObject:Object):Boolean {
		return (mediatorRegistry[viewObject] != null);
	}
	
	/**
	 * Returns String of all view classes that are mapped to mediator classes.
	 * @return		Text with all mapped mediators.
	 */
	public function listMappings():String {
		var retVal:String = "";
		retVal = "==================== MediatorMap Mappings: =====================\n";
		for (var key:Object in mediatorClassRegistry) {
			retVal += "VIEW:'" + key + "'\t> MEDIATED BY > " + mediatorClassRegistry[key] + "\n";
		}
		retVal += "================================================================\n";
		return retVal;
	}

}
}