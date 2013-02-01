// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.events.Event;
import flash.events.IEventDispatcher;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.mvc.Mediator;

/**
 * Handles flex application mediators. 																													</br>
 *  FlexMediatorMap acts a bit differently from MediatorMap. Flex Mediators are not registered until "creationComplete" event is sent.					</br>
 *  This is needed because Flex view objects acts differently then simple AS3 display objects - Flex object can be created in next frames.				</br>
 *  It is common for flex objects to be completed not in the order they were created. Keep this in mind then mediating flex objects.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class FlexMediatorMap extends MediatorMap {
	
	private var uiComponentClass:Class;
	
	/* CONSTRUCTOR */
	public function FlexMediatorMap(moduleName:String, messenger:Messenger, proxyMap:ProxyMap, $uiComponentClass:Class) {
		super(moduleName, messenger, proxyMap);
		uiComponentClass = $uiComponentClass;
	}
	
	/**
	 * Automatically instantiates mediator class(if mapped), handles all injections(including viewObject), and calls onRegister function.
	 * Throws error if mediator class is not mapped to viewObject class.
	 * If object is not initialized - mvcExpress will wait for 'creationComplete' to be dispatched before mediating it.
	 * @param	viewObject	view object to mediate.
	 */
	override public function mediate(viewObject:Object):void {
		if ((viewObject is uiComponentClass) && !viewObject['initialized']) {
			IEventDispatcher(viewObject).addEventListener('creationComplete', handleOnCreationComplete, false, 0, true);
		} else {
			super.mediate(viewObject);
		}
	}
	
	/** Start flex view object mediation after creationComplete is dispatched. */
	private function handleOnCreationComplete(event:Event):void {
		IEventDispatcher(event.target).removeEventListener('creationComplete', handleOnCreationComplete);
		// 
		super.mediate(event.target);
	}
	
	/**
	 * If any mediator is mediating viewObject: it calls onRemove, automatically removes all handler functions listening for messages from that mediator and deletes it.
	 * If flex object is unmediated before 'creationComplete' is dispatched - nothing is done. (because mediation is not done in the first place.)
	 * @param	viewObject	view object witch mediator will be destroyed.
	 */
	override public function unmediate(viewObject:Object):void {
		var mediator:Mediator = mediatorRegistry[viewObject];
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