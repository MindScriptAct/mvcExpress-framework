/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package mvcexpress.extensions.unpuremvc.unpureCore {
import flash.utils.Dictionary;

import mvcexpress.extensions.unpuremvc.patterns.facade.UnpureFacade;
import mvcexpress.extensions.unpuremvc.patterns.observer.*;

/**
 * A Singleton <code>IController</code> implementation.
 *
 * <P>
 * In PureMVC, the <code>Controller</code> class follows the
 * 'Command and Controller' strategy, and assumes these
 * responsibilities:
 * <UL>
 * <LI> Remembering which <code>ICommand</code>s
 * are intended to handle which <code>INotifications</code>.</LI>
 * <LI> Registering itself as an <code>IObserver</code> with
 * the <code>View</code> for each <code>INotification</code>
 * that it has an <code>ICommand</code> mapping for.</LI>
 * <LI> Creating a new instance of the proper <code>ICommand</code>
 * to handle a given <code>INotification</code> when notified by the <code>View</code>.</LI>
 * <LI> Calling the <code>ICommand</code>'s <code>execute</code>
 * method, passing in the <code>INotification</code>.</LI>
 * </UL>
 *
 * <P>
 * Your application must register <code>ICommands</code> with the
 * Controller.
 * <P>
 * The simplest way is to subclass </code>Facade</code>,
 * and use its <code>initializeController</code> method to add your
 * registrations.
 *
 * @see mvcexpress.extensions.unpuremvc.unpureCore.view.View View
 * @see mvcexpress.extensions.unpuremvc.patterns.observer.UnpureObserver Observer
 * @see mvcexpress.extensions.unpuremvc.patterns.observer.UnpureNotification Notification
 * @see mvcexpress.extensions.unpuremvc.patterns.command.UnpureSimpleCommand SimpleCommand
 * @see mvcexpress.extensions.unpuremvc.patterns.command.UnpureMacroCommand MacroCommand
 *
 * @version unpuremvc.1.0.beta2
 */
public class UnpureController {

	// Local reference to View
	protected var view:UnpureView;

	// Singleton instance
	protected static var instanceRegistry:Dictionary = new Dictionary();

	// Message Constants
	protected const SINGLETON_MSG:String = "Controller Singleton already constructed!";
	protected const MULTITON_MSG:String = "Controller instance for this Multiton key already constructed!";

	//
	private var facade:UnpureFacade;
	private var moduleName:String;


	/**
	 * Constructor.
	 *
	 * <P>
	 * This <code>IController</code> implementation is a Singleton,
	 * so you should not call the constructor
	 * directly, but instead call the static Singleton
	 * Factory method <code>Controller.getInstance()</code>
	 *
	 * @throws Error Error if Singleton instance has already been constructed
	 *
	 */
	public function UnpureController(moduleName:String = "$_SINGLECORE_$") {
		if (instanceRegistry[moduleName] != null) {
			if (moduleName == "") {
				throw Error(SINGLETON_MSG);
			} else {
				throw Error(MULTITON_MSG);
			}
		}
		instanceRegistry[moduleName] = this;
		this.moduleName = moduleName;
		facade = UnpureFacade.getInstance(moduleName);
		initializeController();
	}

	/**
	 * Initialize the Singleton <code>Controller</code> instance.
	 *
	 * <P>Called automatically by the constructor.</P>
	 *
	 * <P>Note that if you are using a subclass of <code>View</code>
	 * in your application, you should <i>also</i> subclass <code>Controller</code>
	 * and override the <code>initializeController</code> method in the
	 * following way:</P>
	 *
	 * <listing>
	 *        // ensure that the Controller is talking to my IView implementation
	 *        override public function initializeController(  ) : void
	 *        {
		 *			view = MyView.getInstance();
		 *		}
	 * </listing>
	 *
	 * @return void
	 */
	protected function initializeController():void {
		view = UnpureView.getInstance(moduleName);
	}

	/**
	 * <code>Controller</code> Singleton Factory method.
	 *
	 * @return the Singleton instance of <code>Controller</code>
	 */
	public static function getInstance(moduleName:String = "$_SINGLECORE_$"):UnpureController {
		if (instanceRegistry[moduleName] == null) {
			new UnpureController(moduleName);
		}
		return instanceRegistry[moduleName];
	}

	/**
	 * If an <code>ICommand</code> has previously been registered
	 * to handle a the given <code>INotification</code>, then it is executed.
	 *
	 * @param note an <code>INotification</code>
	 */
	public function executeCommand(note:UnpureNotification):void {
		facade.sendNotification(note.getName(), note.getBody(), note.getType());
	}

	/**
	 * Register a particular <code>ICommand</code> class as the handler
	 * for a particular <code>INotification</code>.
	 *
	 * <P>
	 * If an <code>ICommand</code> has already been registered to
	 * handle <code>INotification</code>s with this name, it is no longer
	 * used, the new <code>ICommand</code> is used instead.</P>
	 *
	 * The Observer for the new ICommand is only created if this the
	 * first time an ICommand has been regisered for this Notification name.
	 *
	 * @param notificationName the name of the <code>INotification</code>
	 * @param commandClassRef the <code>Class</code> of the <code>ICommand</code>
	 */
	public function registerCommand(notificationName:String, commandClassRef:Class):void {
		facade.registerCommand(notificationName, commandClassRef);
	}

	/**
	 * Check if a Command is registered for a given Notification
	 *
	 * @param notificationName
	 * @return whether a Command is currently registered for the given <code>notificationName</code>.
	 */
	public function hasCommand(notificationName:String):Boolean {
		return facade.hasCommand(notificationName);
	}

	/**
	 * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping.
	 *
	 * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
	 */
	public function removeCommand(notificationName:String):void {
		facade.removeCommand(notificationName);
	}

	/**
	 * Remove an IController instance
	 *
	 * @param multitonKey of IController instance to remove
	 */
	public static function removeController(moduleName:String):void {
		delete instanceRegistry[moduleName];
	}

}
}