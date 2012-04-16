// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.base {
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;
import org.mvcexpress.base.interfaces.IMediatorMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.namespace.pureLegsCore;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * Handles application mediators.
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MediatorMap implements IMediatorMap {
	
	protected var proxyMap:ProxyMap;
	protected var messanger:Messenger;
	
	protected var mediatorRegistry:Dictionary = new Dictionary();
	
	protected var viewRegistry:Dictionary = new Dictionary();
	
	public function MediatorMap(messanger:Messenger, proxyMap:ProxyMap) {
		this.messanger = messanger;
		this.proxyMap = proxyMap;
	}
	
	/**
	 * Maps mediator class to view class. Only one mediator class can mediate view class.
	 * @param	viewClass		view class that has to be mediated by mediator class then mediate(viewObject) is called.
	 * @param	mediatorClass	Mediator class that will be instantiated then viewClass object is passed to mediate function.
	 */
	public function map(viewClass:Class, mediatorClass:Class):void {
		CONFIG::debug {
			if (!checkClassSuperclass(mediatorClass, "org.mvcexpress.mvc::Mediator")) {
				throw Error("mediatorClass:" + mediatorClass + " you are trying to map MUST extend: 'org.mvcexpress.mvc::Mediator' class.");
			}
		}
		if (mediatorRegistry[viewClass]) {
			throw Error("Mediator class:" + mediatorRegistry[viewClass] + " is already maped with this view class:" + viewClass + "");
		}
		mediatorRegistry[viewClass] = mediatorClass;
	}
	
	/**
	 * Unmaps any mediator class to given view class.
	 * @param	viewClass	view class to remove maped mediator class from.
	 */
	public function unmap(viewClass:Class):void {
		delete mediatorRegistry[viewClass];
	}
	
	/**
	 * Mediates provided viewObject with maped mediator.
	 * Automaticaly instantiates mediator class(if mapped), handles all injections(including viewObject), and calls onRegister function.
	 * Throws error if mediator class is not mapped to viewObject class.
	 * @param	viewObject	view object to mediate.
	 */
	public function mediate(viewObject:Object):void {
		var viewClass:Class = viewObject.constructor;
		// if .constructor fail to get class - do it using class name. (.constructor is faster but might fail with some object.)
		if (!viewClass) {
			viewClass = Class(getDefinitionByName(getQualifiedClassName(viewObject)));
		}
		// get maped mediator class.
		var mediatorClass:Class = mediatorRegistry[viewClass];
		if (mediatorClass) {
			mediateWith(viewObject, mediatorClass);
		} else {
			throw Error("View object" + viewObject + " class is not mapped with any mediator class. use mediatorMap.map()");
		}
	}
	
	/**
	 * Mediates viewObject with provided mediator.
	 * Automaticaly instantiates provided mediator class, handles all injections(including viewObject), and calls onRegister function.
	 * Throws error if mediator class is not mapped to viewObject class.
	 * @param	viewObject	view object to mediate.
	 * @param	mediatorClass	mediator class to mediate view object.
	 */
	public function mediateWith(viewObject:Object, mediatorClass:Class):void {
		use namespace pureLegsCore;
		CONFIG::debug {
			Mediator.canConstruct = true
		}
		var mediator:Mediator = new mediatorClass();
		CONFIG::debug {
			Mediator.canConstruct = false
		}
		mediator.messanger = messanger;
		mediator.mediatorMap = this;
		
		var viewClass:Class = viewObject.constructor;
		// if .constructor fail to get class - do it using class name. (.constructor is faster but might fail with some object.)
		if (!viewClass) {
			viewClass = Class(getDefinitionByName(getQualifiedClassName(viewObject)));
		}
		
		proxyMap.injectStuff(mediator, mediatorClass, viewObject, viewClass);
		viewRegistry[viewObject] = mediator;
		
		mediator.onRegister();
	}
	
	/**
	 * If any mediator is mediating viewObject: it calls onRemove, automaticaly removes all handler functions listening for messages from that mediator and deletes it.
	 * @param	viewObject	view object witch mediator will be destroed.
	 */
	public function unmediate(viewObject:Object):void {
		var mediator:Mediator = viewRegistry[viewObject];
		if (mediator) {
			mediator.onRemove();
			use namespace pureLegsCore;
			mediator.removeAllHandlers();
			delete viewRegistry[viewObject];
		} else {
			throw Error("View object:" + viewObject + " has no mediator created for it.");
		}
	}
	
	/**
	 * Dispose modiatorMap on module shutDown
	 * @private
	 */
	pureLegsCore function dispose():void {
		for each (var viewObject:Object in viewRegistry) {
			unmediate(viewObject);
		}
		proxyMap = null;
		messanger = null;
		mediatorRegistry = null;
		viewRegistry = null;
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
		if (mediatorRegistry[viewClass]) {
			if (mediatorRegistry[viewClass] == mediatorClass) {
				retVal = true;
			}
		}
		return retVal;
	}
	
	/**
	 * will trace all view classes that are maped to mediator classes.
	 */
	public function listMappings():void {
		trace("==================== MediatorMap Mappings: =====================");
		for (var key:Object in mediatorRegistry) {
			trace("VIEW:'" + key + "'\t> MEDIATED BY > " + mediatorRegistry[key]);
		}
		trace("================================================================");
	}

}
}