/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package mvcexpress.extensions.unpuremvc.patterns.command {

import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.unpuremvc.patterns.facade.UnpureFacade;
import mvcexpress.extensions.unpuremvc.patterns.observer.UnpureNotification;
import mvcexpress.mvc.Command;

/**
 * A base <code>ICommand</code> implementation.
 *
 * <P>
 * Your subclass should override the <code>execute</code>
 * method where your business logic will handle the <code>INotification</code>. </P>
 *
 * @see mvcexpress.extensions.unpuremvc.unpureCore.controller.Controller Controller
 * @see mvcexpress.extensions.unpuremvc.patterns.observer.UnpureNotification Notification
 * @see mvcexpress.extensions.unpuremvc.patterns.command.UnpureMacroCommand MacroCommand
 *
 * @version unpuremvc.1.0.beta2
 */
public class UnpureSimpleCommand extends Command implements UnpureICommand {

	/**
	 * Fulfill the use-case initiated by the given <code>INotification</code>.
	 *
	 * <P>
	 * In the Command Pattern, an application use-case typically
	 * begins with some user action, which results in an <code>INotification</code> being broadcast, which
	 * is handled by business logic in the <code>execute</code> method of an
	 * <code>ICommand</code>.</P>
	 *
	 * @param notification the <code>INotification</code> to handle.
	 */
	public function execute(notification:UnpureNotification):void {

	}

	//----------------------------------
	//	class Notifier
	//----------------------------------

	private var _facade:UnpureFacade;

	// Local reference to the Facade Singleton
	// Return the Multiton Facade instance
	protected function get facade():UnpureFacade {
		if (!_facade) {
			use namespace pureLegsCore;

			_facade = UnpureFacade.getInstance(messenger.moduleName);
		}
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
		sendMessage(notificationName, body);
	}
}
}