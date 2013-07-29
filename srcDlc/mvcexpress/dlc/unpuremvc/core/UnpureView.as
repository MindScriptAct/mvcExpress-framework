/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package mvcexpress.dlc.unpuremvc.core {

import flash.utils.Dictionary;

import mvcexpress.dlc.unpuremvc.patterns.facade.UnpureFacade;
import mvcexpress.dlc.unpuremvc.patterns.mediator.UnpureMediator;
import mvcexpress.dlc.unpuremvc.patterns.observer.UnpureNotification;
import mvcexpress.dlc.unpuremvc.patterns.observer.UnpureObserver;
import mvcexpress.dlc.unpuremvc.patterns.observer.observerCommand.UnpureObserverCommand;

/**
 * A Singleton <code>IView</code> implementation.
 *
 * <P>
 * In PureMVC, the <code>View</code> class assumes these responsibilities:
 * <UL>
 * <LI>Maintain a cache of <code>IMediator</code> instances.</LI>
 * <LI>Provide methods for registering, retrieving, and removing <code>IMediators</code>.</LI>
 * <LI>Notifiying <code>IMediators</code> when they are registered or removed.</LI>
 * <LI>Managing the observer lists for each <code>INotification</code> in the application.</LI>
 * <LI>Providing a method for attaching <code>IObservers</code> to an <code>INotification</code>'s observer list.</LI>
 * <LI>Providing a method for broadcasting an <code>INotification</code>.</LI>
 * <LI>Notifying the <code>IObservers</code> of a given <code>INotification</code> when it broadcast.</LI>
 * </UL>
 *
 * @see mvcexpress.dlc.unpuremvc.patterns.mediator.UnpureMediator Mediator
 * @see mvcexpress.dlc.unpuremvc.patterns.observer.UnpureObserver Observer
 * @see mvcexpress.dlc.unpuremvc.patterns.observer.UnpureNotification Notification
 */
public class UnpureView {

	// Mapping of Mediator names to Mediator instances
//	protected var mediatorMap:Array;

	// Mapping of Notification names to Observer lists
//	protected var observerMap:Array;

	// Singleton instance
	protected static var instanceRegistry:Dictionary = new Dictionary();


	// Message Constants
	protected const SINGLETON_MSG:String = "View Singleton already constructed!";
	protected const MULTITON_MSG:String = "View instance for this Multiton key already constructed!";

	//
	private var moduleName:String;
	private var facade:UnpureFacade;

	/**
	 * Constructor.
	 *
	 * <P>
	 * This <code>IView</code> implementation is a Singleton,
	 * so you should not call the constructor
	 * directly, but instead call the static Singleton
	 * Factory method <code>View.getInstance()</code>
	 *
	 * @throws Error Error if Singleton instance has already been constructed
	 *
	 */
	public function UnpureView(moduleName:String = "$_SINGLECORE_$") {
		if (instanceRegistry[moduleName] != null) {
			if (moduleName == "") {
				throw Error(SINGLETON_MSG);
			} else {
				throw Error(MULTITON_MSG);
			}
		}
		this.moduleName = moduleName;
		instanceRegistry[moduleName] = this;
		facade = UnpureFacade.getInstance(moduleName);
//		mediatorMap = new Array();
//		observerMap = new Array();
		initializeView();
	}

	/**
	 * Initialize the Singleton View instance.
	 *
	 * <P>
	 * Called automatically by the constructor, this
	 * is your opportunity to initialize the Singleton
	 * instance in your subclass without overriding the
	 * constructor.</P>
	 *
	 * @return void
	 */
	protected function initializeView():void {
	}

	/**
	 * UnpureView Singleton Factory method.
	 *
	 * @return the Singleton instance of <code>View</code>
	 */
	public static function getInstance(moduleName:String = "$_SINGLECORE_$"):UnpureView {
		if (instanceRegistry[moduleName] == null) {
			new UnpureView(moduleName);
		}
		return instanceRegistry[moduleName];
	}

	/**
	 * Register an <code>IObserver</code> to be notified
	 * of <code>INotifications</code> with a given name.
	 *
	 * @param notificationName the name of the <code>INotifications</code> to notify this <code>IObserver</code> of
	 * @param observer the <code>IObserver</code> to register
	 */
	public function registerObserver(notificationName:String, observer:UnpureObserver):void {
//		var observers:Array = observerMap[notificationName];
//		if (observers) {
//			observers.push(observer);
//		} else {
//			observerMap[notificationName] = [observer];
//		}

		facade.registerCommand(notificationName, UnpureObserverCommand);
		UnpureObserverCommand.addObserver(notificationName, observer);
	}

	/**
	 * Notify the <code>IObservers</code> for a particular <code>INotification</code>.
	 *
	 * <P>
	 * All previously attached <code>IObservers</code> for this <code>INotification</code>'s
	 * list are notified and are passed a reference to the <code>INotification</code> in
	 * the order in which they were registered.</P>
	 *
	 * @param notification the <code>INotification</code> to notify <code>IObservers</code> of.
	 */
	public function notifyObservers(notification:UnpureNotification):void {
//		if (observerMap[notification.getName()] != null) {
//
//			// Get a reference to the observers list for this notification name
//			var observers_ref:Array = observerMap[notification.getName()] as Array;
//
//			// Copy observers from reference array to working array,
//			// since the reference array may change during the notification loop
//			var observers:Array = new Array();
//			var observer:UnpureObserver;
//			for (var i:Number = 0; i < observers_ref.length; i++) {
//				observer = observers_ref[i] as UnpureObserver;
//				observers.push(observer);
//			}
//
//			// Notify Observers from the working array
//			for (i = 0; i < observers.length; i++) {
//				observer = observers[i] as UnpureObserver;
//				observer.notifyObserver(notification);
//			}
//		}

		facade.sendNotification(notification.getName(), notification.getBody(), notification.getType());
	}

	/**
	 * Remove the observer for a given notifyContext from an observer list for a given Notification name.
	 * <P>
	 * @param notificationName which observer list to remove from
	 * @param notifyContext remove the observer with this object as its notifyContext
	 */
	public function removeObserver(notificationName:String, notifyContext:Object):void {
//		// the observer list for the notification under inspection
//		var observers:Array = observerMap[notificationName] as Array;
//
//		// find the observer for the notifyContext
//		for (var i:int = 0; i < observers.length; i++) {
//			if (UnpureObserver(observers[i]).compareNotifyContext(notifyContext) == true) {
//				// there can only be one Observer for a given notifyContext
//				// in any given Observer list, so remove it and break
//				observers.splice(i, 1);
//				break;
//			}
//		}
//
//		// Also, when a Notification's Observer list length falls to
//		// zero, delete the notification key from the observer map
//		if (observers.length == 0) {
//			delete observerMap[notificationName];
//		}

		UnpureObserverCommand.removeObserver(notificationName, notifyContext);
	}

	/**
	 * Register an <code>IMediator</code> instance with the <code>View</code>.
	 *
	 * <P>
	 * Registers the <code>IMediator</code> so that it can be retrieved by name,
	 * and further interrogates the <code>IMediator</code> for its
	 * <code>INotification</code> interests.</P>
	 * <P>
	 * If the <code>IMediator</code> returns any <code>INotification</code>
	 * names to be notified about, an <code>Observer</code> is created encapsulating
	 * the <code>IMediator</code> instance's <code>handleNotification</code> method
	 * and registering it as an <code>Observer</code> for all <code>INotifications</code> the
	 * <code>IMediator</code> is interested in.</p>
	 *
	 * @param mediatorName the name to associate with this <code>IMediator</code> instance
	 * @param mediator a reference to the <code>IMediator</code> instance
	 */
	public function registerMediator(mediator:UnpureMediator):void {
//		// do not allow re-registration (you must to removeMediator fist)
//		if (mediatorMap[mediator.getMediatorName()] != null) return;
//
//		// Register the Mediator for retrieval by name
//		mediatorMap[mediator.getMediatorName()] = mediator;
//
//		// Get Notification interests, if any.
//		var interests:Array = mediator.listNotificationInterests();
//
//		// Register Mediator as an observer for each of its notification interests
//		if (interests.length > 0) {
//			// Create Observer referencing this mediator's handlNotification method
//			var observer:UnpureObserver = new UnpureObserver(mediator.handleNotification, mediator);
//
//			// Register Mediator as Observer for its list of Notification interests
//			for (var i:Number = 0; i < interests.length; i++) {
//				registerObserver(interests[i], observer);
//			}
//		}
//
//		// alert the mediator that it has been registered
//		mediator.onRegister();

		facade.registerMediator(mediator);

	}

	/**
	 * Retrieve an <code>IMediator</code> from the <code>View</code>.
	 *
	 * @param mediatorName the name of the <code>IMediator</code> instance to retrieve.
	 * @return the <code>IMediator</code> instance previously registered with the given <code>mediatorName</code>.
	 */
	public function retrieveMediator(mediatorName:String):UnpureMediator {
//		return mediatorMap[mediatorName];

		return facade.retrieveMediator(mediatorName);
	}

	/**
	 * Remove an <code>IMediator</code> from the <code>View</code>.
	 *
	 * @param mediatorName name of the <code>IMediator</code> instance to be removed.
	 * @return the <code>IMediator</code> that was removed from the <code>View</code>
	 */
	public function removeMediator(mediatorName:String):UnpureMediator {
		// Retrieve the named mediator
//		var mediator:UnpureMediator = mediatorMap[mediatorName] as UnpureMediator;
//
//		if (mediator) {
//			// for every notification this mediator is interested in...
//			var interests:Array = mediator.listNotificationInterests();
//			for (var i:Number = 0; i < interests.length; i++) {
//				// remove the observer linking the mediator
//				// to the notification interest
//				removeObserver(interests[i], mediator);
//			}
//
//			// remove the mediator from the map
//			delete mediatorMap[mediatorName];
//
//			// alert the mediator that it has been removed
//			mediator.onRemove();
//		}
//		return mediator;

		var mediator:UnpureMediator = facade.retrieveMediator(mediatorName);
		facade.removeMediator(mediatorName);
		return mediator;

	}

	/**
	 * Check if a Mediator is registered or not
	 *
	 * @param mediatorName
	 * @return whether a Mediator is registered with the given <code>mediatorName</code>.
	 */
	public function hasMediator(mediatorName:String):Boolean {
//		return mediatorMap[mediatorName] != null;

		return facade.hasMediator(mediatorName);
	}

	/**
	 * Remove an IView instance
	 *
	 * @param multitonKey of IView instance to remove
	 */
	public static function removeView(moduleName:String):void {
		delete instanceRegistry[moduleName];
	}

}
}