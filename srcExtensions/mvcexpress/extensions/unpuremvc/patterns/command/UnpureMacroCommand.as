/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package mvcexpress.extensions.unpuremvc.patterns.command {

import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.unpuremvc.patterns.facade.UnpureFacade;
import mvcexpress.extensions.unpuremvc.patterns.observer.*;
import mvcexpress.mvc.Command;

/**
 * A base <code>ICommand</code> implementation that executes other <code>ICommand</code>s.
 *
 * <P>
 * A <code>MacroCommand</code> maintains an list of
 * <code>ICommand</code> Class references called <i>SubCommands</i>.</P>
 *
 * <P>
 * When <code>execute</code> is called, the <code>MacroCommand</code>
 * instantiates and calls <code>execute</code> on each of its <i>SubCommands</i> turn.
 * Each <i>SubCommand</i> will be passed a reference to the original
 * <code>INotification</code> that was passed to the <code>MacroCommand</code>'s
 * <code>execute</code> method.</P>
 *
 * <P>
 * Unlike <code>SimpleCommand</code>, your subclass
 * should not override <code>execute</code>, but instead, should
 * override the <code>initializeMacroCommand</code> method,
 * calling <code>addSubCommand</code> once for each <i>SubCommand</i>
 * to be executed.</P>
 *
 * <P>
 *
 * @see mvcexpress.extensions.unpuremvc.unpureCore.controller.Controller Controller
 * @see mvcexpress.extensions.unpuremvc.patterns.observer.UnpureNotification Notification
 * @see mvcexpress.extensions.unpuremvc.patterns.command.UnpureSimpleCommand SimpleCommand
 *
 * @version unpuremvc.1.0.beta2
 */
public class UnpureMacroCommand extends Command implements UnpureICommand {

	private var subCommands:Array;

	/**
	 * Constructor.
	 *
	 * <P>
	 * You should not need to define a constructor,
	 * instead, override the <code>initializeMacroCommand</code>
	 * method.</P>
	 *
	 * <P>
	 * If your subclass does define a constructor, be
	 * sure to call <code>super()</code>.</P>
	 */
	public function UnpureMacroCommand() {
		subCommands = new Array();
		initializeMacroCommand();
	}

	/**
	 * Initialize the <code>MacroCommand</code>.
	 *
	 * <P>
	 * In your subclass, override this method to
	 * initialize the <code>MacroCommand</code>'s <i>SubCommand</i>
	 * list with <code>ICommand</code> class references like
	 * this:</P>
	 *
	 * <listing>
	 *        // Initialize MyMacroCommand
	 *        override protected function initializeMacroCommand( ) : void
	 *        {
		 *			addSubCommand( com.me.myapp.controller.FirstCommand );
		 *			addSubCommand( com.me.myapp.controller.SecondCommand );
		 *			addSubCommand( com.me.myapp.controller.ThirdCommand );
		 *		}
	 * </listing>
	 *
	 * <P>
	 * Note that <i>SubCommand</i>s may be any <code>ICommand</code> implementor,
	 * <code>MacroCommand</code>s or <code>SimpleCommands</code> are both acceptable.
	 */
	protected function initializeMacroCommand():void {
	}

	/**
	 * Add a <i>SubCommand</i>.
	 *
	 * <P>
	 * The <i>SubCommands</i> will be called in First In/First Out (FIFO)
	 * order.</P>
	 *
	 * @param commandClassRef a reference to the <code>Class</code> of the <code>ICommand</code>.
	 */
	protected function addSubCommand(commandClassRef:Class):void {
		subCommands.push(commandClassRef);
	}

	/**
	 * Execute this <code>MacroCommand</code>'s <i>SubCommands</i>.
	 *
	 * <P>
	 * The <i>SubCommands</i> will be called in First In/First Out (FIFO)
	 * order.
	 *
	 * @param notification the <code>INotification</code> object to be passsed to each <i>SubCommand</i>.
	 */
	public final function execute(notification:UnpureNotification):void {
		for (var i:int = 0; i < subCommands.length; i++) {
			commandMap.execute(subCommands[i], notification);
		}
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