package org.pureLegs.core {
import flash.utils.Dictionary;
import org.pureLegs.core.interfaces.IMediatorMap;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.mvc.Mediator;
import org.pureLegs.namespace.pureLegsCore;

/**
 * Handles application mediators.
 * @author rbanevicius
 */
public class MediatorMap implements IMediatorMap {
	private var modelMap:ModelMap;
	private var messanger:Messenger;
	
	private var mediatorRegistry:Dictionary = new Dictionary();
	
	private var viewRegistry:Dictionary = new Dictionary();	
	
	public function MediatorMap(messanger:Messenger, modelMap:ModelMap){
		this.messanger = messanger;
		this.modelMap = modelMap;
	}
	
	/**
	 * Maps mediator class to view class. Only one mediator class can mediate view class.
	 * @param	viewClass		view class that has to be mediated by mediator class then mediate(viewObject) is called.
	 * @param	mediatorClass	Mediator class that will be instantiated then viewClass object is passed to mediate function.
	 */
	public function map(viewClass:Class, mediatorClass:Class):void {
		if (mediatorRegistry[viewClass]){
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
	 * Automaticaly instantiates mediator class(if mapped), handles all injections(including viewObject), and calls onRegister function.
	 * Throws error if mediator class is not mapped to viewObject class. 
	 * @param	viewObject	view object to mediate.
	 */
	public function mediate(viewObject:Object):void {
		var mediatorClass:Class = mediatorRegistry[viewObject.constructor]
		if (mediatorClass){
			var mediator:Mediator = new mediatorClass();
			use namespace pureLegsCore;
			mediator.messanger = messanger;
			mediator.mediatorMap = this;
			
			modelMap.injectStuff(mediator, mediatorClass, viewObject, viewObject.constructor);
			viewRegistry[viewObject] = mediator;
			
			mediator.onRegister();
		} else {
			throw Error("View object class is not mapped with any mediator class. us. mediatorMap.mapMediator()");
		}
	}
	
	/**
	 * If any mediator is mediating viewObject: it calls onRemove, automaticaly removes all handler functions listening for messages from that mediator and deletes it.
	 * @param	viewObject	view object witch mediator will be destroed.
	 */
	public function unmediate(viewObject:Object):void {
		var mediator:Mediator = viewRegistry[viewObject];
		if (mediator){
			mediator.onRemove();
			use namespace pureLegsCore;
			mediator.removeAllHandlers();
			delete viewRegistry[viewObject];
		} else {
			throw Error("View object has no mediator created for it.");
		}
	}
	
	/* Dispose modiatorMap on module shutDown */
	pureLegsCore function dispose():void {
		for each (var viewObject:Object in viewRegistry) {
			unmediate(viewObject);
		}
		modelMap = null;
		messanger = null;
		mediatorRegistry = null;
		viewRegistry = null;	
	}

}
}