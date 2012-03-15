package org.mvcexpress.base {
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.base.interfaces.IMediatorMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.namespace.pureLegsCore;

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
		if (mediatorRegistry[viewClass]) {
			throw Error("Mediator class is already maped with this view class");
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
			throw Error("View object class is not mapped with any mediator class. us. mediatorMap.mapMediator()");
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
		var mediator:Mediator = new mediatorClass();
		use namespace pureLegsCore;
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
			throw Error("View object has no mediator created for it.");
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

}
}