package mvcexpress.extensions.unpuremvc.patterns.observer.observerCommand {
import flash.utils.Dictionary;

import mvcexpress.extensions.unpuremvc.patterns.observer.UnpureNotification;
import mvcexpress.extensions.unpuremvc.patterns.observer.UnpureObserver;
import mvcexpress.mvc.PooledCommand;

/**
 * @version unpuremvc.1.0.beta2
 */
public class UnpureObserverCommand extends PooledCommand {

	private static var $observerRegistry:Dictionary = new Dictionary();

	public function execute(notification:UnpureNotification):void {
		// Get a reference to the observers list for this notification name
		var observers_ref:Array = $observerRegistry[notification.getName()];
		if (observers_ref) {

			// Copy observers from reference array to working array,
			// since the reference array may change during the notification loop
			var observers:Array = new Array();
			var observer:UnpureObserver;
			for (var i:Number = 0; i < observers_ref.length; i++) {
				observer = observers_ref[i] as UnpureObserver;
				observers.push(observer);
			}

			// Notify Observers from the working array
			for (i = 0; i < observers.length; i++) {
				observer = observers[i] as UnpureObserver;
				observer.notifyObserver(notification);
			}
		}

	}

	public static function addObserver(notificationName:String, observer:UnpureObserver):void {
		var observers:Array = $observerRegistry[notificationName];
		if (observers) {
			observers.push(observer);
		} else {
			$observerRegistry[notificationName] = [observer];
		}
	}

	public static function removeObserver(notificationName:String, notifyContext:Object):void {
		var observers:Array = $observerRegistry[notificationName];
		if (observers) {
			for (var i:int = 0; i < observers.length; i++) {
				if (observers[i].getNotifyContext() == notifyContext) {
					observers.splice(i, 1);
				}
			}
		}
	}
}
}
