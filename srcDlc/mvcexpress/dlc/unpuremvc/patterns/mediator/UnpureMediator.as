/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package mvcexpress.dlc.unpuremvc.patterns.mediator {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.dlc.unpuremvc.core.messenger.UnpureMessenger;
import mvcexpress.dlc.unpuremvc.patterns.facade.UnpureFacade;
import mvcexpress.dlc.unpuremvc.patterns.observer.*;
import mvcexpress.mvc.Mediator;

/**
 * A base <code>IMediator</code> implementation.
 *
 * @see mvcexpress.dlc.unpuremvc.core.view.View View
 */
public class UnpureMediator extends Mediator {

	// the mediator name
	protected var mediatorName:String;

	// The view component
	protected var viewComponent:Object;

	/**
	 * The name of the <code>Mediator</code>.
	 *
	 * <P>
	 * Typically, a <code>Mediator</code> will be written to serve
	 * one specific control or group controls and so,
	 * will not have a need to be dynamically named.</P>
	 */
	public static const NAME:String = 'Mediator';

	/**
	 * Constructor.
	 */
	public function UnpureMediator(mediatorName:String = null, viewComponent:Object = null) {
//		this.mediatorName = (mediatorName != null) ? mediatorName : NAME;
//		this.viewComponent = viewComponent;

		use namespace pureLegsCore;

		Mediator.canConstruct = true;
		super();
		Mediator.canConstruct = false;


		this.mediatorName = (mediatorName != null) ? mediatorName : NAME;
		this.viewComponent = viewComponent;
	}

	pureLegsCore function initMediator(moduleName:String):void {
		use namespace pureLegsCore;

		this.moduleName = moduleName;
		moduleName = facade.getModuleName();
		messenger = facade.getMessender();
		proxyMap = facade.getProxyMap();
		mediatorMap = facade.getMediatorMap();
	}

	pureLegsCore function initNotificationHandling():void {
		var reactTo:Array = listNotificationInterests();
		for (var i:int = 0; i < reactTo.length; i++) {
			addHandler(reactTo[i], handleRawNotification);
		}
	}

	// bridge function.
	private function handleRawNotification(body:Object):void {
		use namespace pureLegsCore;
		var messageType:String = (messenger as UnpureMessenger).getLastMessageType();
		handleNotification(new UnpureNotification(messageType, body));
	}

	/**
	 * Get the name of the <code>Mediator</code>.
	 * @return the Mediator name
	 */
	public function getMediatorName():String {
		return mediatorName;
	}

	/**
	 * Set the <code>IMediator</code>'s view component.
	 *
	 * @param Object the view component
	 */
	public function setViewComponent(viewComponent:Object):void {
		this.viewComponent = viewComponent;
	}

	/**
	 * Get the <code>Mediator</code>'s view component.
	 *
	 * <P>
	 * Additionally, an implicit getter will usually
	 * be defined in the subclass that casts the view
	 * object to a type, like this:</P>
	 *
	 * <listing>
	 *        private function get comboBox : mx.controls.ComboBox
	 *        {
		 *			return viewComponent as mx.controls.ComboBox;
		 *		}
	 * </listing>
	 *
	 * @return the view component
	 */
	public function getViewComponent():Object {
		return viewComponent;
	}

	/**
	 * List the <code>INotification</code> names this
	 * <code>Mediator</code> is interested in being notified of.
	 *
	 * @return Array the list of <code>INotification</code> names
	 */
	public function listNotificationInterests():Array {
		return [];
	}

	/**
	 * Handle <code>INotification</code>s.
	 *
	 * <P>
	 * Typically this will be handled in a switch statement,
	 * with one 'case' entry per <code>INotification</code>
	 * the <code>Mediator</code> is interested in.
	 */
	public function handleNotification(notification:UnpureNotification):void {
	}

	/**
	 * Called by the View when the Mediator is registered
	 */
//	public function onRegister():void {
//	}

	/**
	 * Called by the View when the Mediator is removed
	 */
//	public function onRemove():void {
//	}

	//----------------------------------
	//	class Notifier
	//----------------------------------

	private var _facade:UnpureFacade;

	// Local reference to the Facade Singleton
	// Return the Multiton Facade instance
	protected function get facade():UnpureFacade {
		if (!_facade) {
			use namespace pureLegsCore;

			_facade = UnpureFacade.getInstance(this.moduleName);
		}
		//if (multitonKey == null) throw Error(MULTITON_MSG);
		return _facade;
	}

	/**
	 * Create and send an <code>INotification</code>.
	 *
	 * <P>
	 * Keeps us from having to construct new INotification
	 * instances in our implementation code.
	 * @param notificationName the name of the notiification to send
	 * @param body the body of the notification (optional)
	 * @param type the type of the notification (optional)
	 */
	public function sendNotification(notificationName:String, body:Object = null, type:String = null):void {
		//facade.sendNotification(notificationName, body, type);
//		UnpureFacade.notificationNameStack.push(notificationName);
//		UnpureFacade.notificationTypeStack.push(type);
		sendMessage(notificationName, body);
//		UnpureFacade.notificationNameStack.pop();
//		UnpureFacade.notificationTypeStack.pop();
	}

}
}