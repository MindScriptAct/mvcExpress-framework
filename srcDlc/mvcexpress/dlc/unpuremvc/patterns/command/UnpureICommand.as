/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package mvcexpress.dlc.unpuremvc.patterns.command {
import mvcexpress.dlc.unpuremvc.patterns.observer.UnpureNotification;

/**
 * The interface definition for a PureMVC Command.
 *
 * @see mvcexpress.dlc.unpuremvc.interfaces INotification
 */
public interface UnpureICommand {
	/**
	 * Execute the <code>ICommand</code>'s logic to handle a given <code>INotification</code>.
	 *
	 * @param note an <code>INotification</code> to handle.
	 */
	function execute(notification:UnpureNotification):void;
}
}