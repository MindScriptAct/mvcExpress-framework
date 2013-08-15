/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package mvcexpress.extensions.unpuremvc.patterns.proxy {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.unpuremvc.patterns.facade.UnpureFacade;
import mvcexpress.mvc.Proxy;

/**
 * A base <code>IProxy</code> implementation.
 *
 * <P>
 * In PureMVC, <code>Proxy</code> classes are used to manage parts of the
 * application's data model. </P>
 *
 * <P>
 * A <code>Proxy</code> might simply manage a reference to a local data object,
 * in which case interacting with it might involve setting and
 * getting of its data in synchronous fashion.</P>
 *
 * <P>
 * <code>Proxy</code> classes are also used to encapsulate the application's
 * interaction with remote services to save or retrieve data, in which case,
 * we adopt an asyncronous idiom; setting data (or calling a method) on the
 * <code>Proxy</code> and listening for a <code>Notification</code> to be sent
 * when the <code>Proxy</code> has retrieved the data from the service. </P>
 *
 * @see mvcexpress.extensions.unpuremvc.unpureCore.model.Model Model
 *
 * @version unpuremvc.1.0.beta2
 */
public class UnpureProxy extends Proxy {

	public static var NAME:String = 'Proxy';

	// the proxy name
	protected var proxyName:String;

	// the data object
	protected var data:Object;

	/**
	 * Constructor
	 */
	public function UnpureProxy(proxyName:String = null, data:Object = null) {
		this.proxyName = (proxyName != null) ? proxyName : NAME;
		if (data != null) setData(data);
	}

	/**
	 * Get the proxy name
	 */
	public function getProxyName():String {
		return proxyName;
	}

	/**
	 * Set the data object
	 */
	public function setData(data:Object):void {
		this.data = data;
	}

	/**
	 * Get the data object
	 */
	public function getData():Object {
		return data;
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