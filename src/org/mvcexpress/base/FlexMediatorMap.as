package org.mvcexpress.base {
import flash.events.Event;
import flash.events.IEventDispatcher;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Handles flex application mediators.
 *  The only reason for this extra layer is to handle "creationComplete" flex event before 
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class FlexMediatorMap extends MediatorMap {
	private var uiComponentClass:Class;
	
	/**
	 * Maps mediator class to view class. Only one mediator class can mediate view class.
	 * @param	viewClass		view class that has to be mediated by mediator class then mediate(viewObject) is called.
	 * @param	mediatorClass	Mediator class that will be instantiated then viewClass object is passed to mediate function.
	 * @param	uiComponentClass	Lowest posible flex visual object class.
	 */
	// TODO : check if UIComponent must be used as lowest Flex visual object... maybe it should be FlexSprite???
	public function FlexMediatorMap(messenger:Messenger, proxyMap:ProxyMap, uiComponentClass:Class) {
		super(messenger, proxyMap);
		this.uiComponentClass = uiComponentClass;
	}
	
	/**
	 * Automaticaly instantiates mediator class(if mapped), handles all injections(including viewObject), and calls onRegister function.
	 * Throws error if mediator class is not mapped to viewObject class.
	 * If objcet is not initialized - mvcExpress will wait for 'creationComplete' to be dispatched before mediateng it.
	 * @param	viewObject	view object to mediate.
	 */
	override public function mediate(viewObject:Object):void {
		if ((viewObject is uiComponentClass) && !viewObject['initialized']) {
			IEventDispatcher(viewObject).addEventListener('creationComplete', handleOnCreationComplete, false, 0, true);
		} else {
			super.mediate(viewObject);
		}
	}
	
	/* Start flex view object mediaton after creationComplete is dispached. */
	private function handleOnCreationComplete(event:Event):void {
		IEventDispatcher(event.target).removeEventListener('creationComplete', handleOnCreationComplete);
		// 
		super.mediate(event.target);
	}
	
	/**
	 * If any mediator is mediating viewObject: it calls onRemove, automaticaly removes all handler functions listening for messages from that mediator and deletes it.
	 * If flex object is unmediated before 'creationComplete' is dispached - nothing is done. (because mediation is not done in the first place.)
	 * @param	viewObject	view object witch mediator will be destroed.
	 */
	override public function unmediate(viewObject:Object):void {
		var mediator:Mediator = viewRegistry[viewObject];
		if (mediator) {
			super.unmediate(viewObject);
		} else {
			// remove creationComplete handlers if any.
			if (IEventDispatcher(viewObject).hasEventListener('creationComplete')) {
				IEventDispatcher(viewObject).removeEventListener('creationComplete', handleOnCreationComplete);
			}
		}
	}

}
}