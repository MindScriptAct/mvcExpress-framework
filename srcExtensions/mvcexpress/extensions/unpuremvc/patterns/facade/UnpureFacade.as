/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
 */
package mvcexpress.extensions.unpuremvc.patterns.facade {

import flash.utils.Dictionary;

import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.unpuremvc.core.UnpureCommandMap;
import mvcexpress.extensions.unpuremvc.core.messenger.UnpureMessenger;
import mvcexpress.extensions.unpuremvc.patterns.mediator.UnpureMediator;
import mvcexpress.extensions.unpuremvc.patterns.observer.UnpureNotification;
import mvcexpress.extensions.unpuremvc.patterns.proxy.UnpureProxy;
import mvcexpress.extensions.unpuremvc.unpureCore.*;
import mvcexpress.modules.ModuleCore;

/**
 * A base Singleton/Multiton <code>IFacade</code> implementation.
 *
 * <P>
 * In PureMVC, the <code>Facade</code> class assumes these
 * responsibilities:
 * <UL>
 * <LI>Initializing the <code>Model</code>, <code>View</code>
 * and <code>Controller</code> Singletons.</LI>
 * <LI>Providing all the methods defined by the <code>IModel,
 * IView, & IController</code> interfaces.</LI>
 * <LI>Providing the ability to override the specific <code>Model</code>,
 * <code>View</code> and <code>Controller</code> Singletons created.</LI>
 * <LI>Providing a single point of contact to the application for
 * registering <code>Commands</code> and notifying <code>Observers</code></LI>
 * </UL>
 * <P>
 * Example usage:
 * <listing>
 *
 *    import com.me.myapp.model.~~;
 *    import com.me.myapp.view.~~;
 *    import com.me.myapp.controller.~~;
 *
 *    public class MyFacade extends Facade
 *    {
	 *		// Notification constants. The Facade is the ideal
	 *		// location for these constants, since any part
	 *		// of the application participating in PureMVC
	 *		// Observer Notification will know the Facade.
	 *		public static const GO_COMMAND:String = "go";
	 *
	 *		// Override Singleton Factory method
	 *		public static function getInstance() : MyFacade {
	 *			if (instance == null) instance = new MyFacade();
	 *			return instance as MyFacade;
	 *		}
	 *
	 *		// optional initialization hook for Facade
	 *		override public function initializeFacade() : void {
	 *			super.initializeFacade();
	 *			// do any special subclass initialization here
	 *		}
	 *
	 *		// optional initialization hook for Controller
	 *		override public function initializeController() : void {
	 *			// call super to use the PureMVC Controller Singleton.
	 *			super.initializeController();
	 *
	 *			// Otherwise, if you're implmenting your own
	 *			// IController, then instead do:
	 *			// if ( controller != null ) return;
	 *			// controller = MyAppController.getInstance();
	 *
	 *			// do any special subclass initialization here
	 *			// such as registering Commands
	 *			registerCommand( GO_COMMAND, com.me.myapp.controller.GoCommand )
	 *		}
	 *
	 *		// optional initialization hook for Model
	 *		override public function initializeModel() : void {
	 *			// call super to use the PureMVC Model Singleton.
	 *			super.initializeModel();
	 *
	 *			// Otherwise, if you're implmenting your own
	 *			// IModel, then instead do:
	 *			// if ( model != null ) return;
	 *			// model = MyAppModel.getInstance();
	 *
	 *			// do any special subclass initialization here
	 *			// such as creating and registering Model proxys
	 *			// that don't require a facade reference at
	 *			// construction time, such as fixed type lists
	 *			// that never need to send Notifications.
	 *			regsiterProxy( new USStateNamesProxy() );
	 *
	 *			// CAREFUL: Can't reference Facade instance in constructor
	 *			// of new Proxys from here, since this step is part of
	 *			// Facade construction!  Usually, Proxys needing to send
	 *			// notifications are registered elsewhere in the app
	 *			// for this reason.
	 *		}
	 *
	 *		// optional initialization hook for View
	 *		override public function initializeView() : void {
	 *			// call super to use the PureMVC View Singleton.
	 *			super.initializeView();
	 *
	 *			// Otherwise, if you're implmenting your own
	 *			// IView, then instead do:
	 *			// if ( view != null ) return;
	 *			// view = MyAppView.getInstance();
	 *
	 *			// do any special subclass initialization here
	 *			// such as creating and registering Mediators
	 *			// that do not need a Facade reference at construction
	 *			// time.
	 *			registerMediator( new LoginMediator() );
	 *
	 *			// CAREFUL: Can't reference Facade instance in constructor
	 *			// of new Mediators from here, since this is a step
	 *			// in Facade construction! Usually, all Mediators need
	 *			// receive notifications, and are registered elsewhere in
	 *			// the app for this reason.
	 *		}
	 *	}
 * </listing>
 *
 * @see mvcexpress.extensions.unpuremvc.unpureCore.model.Model Model
 * @see mvcexpress.extensions.unpuremvc.unpureCore.view.View View
 * @see mvcexpress.extensions.unpuremvc.unpureCore.controller.Controller Controller
 * @see mvcexpress.extensions.unpuremvc.patterns.observer.UnpureNotification Notification
 * @see mvcexpress.extensions.unpuremvc.patterns.mediator.UnpureMediator Mediator
 * @see mvcexpress.extensions.unpuremvc.patterns.proxy.UnpureProxy Proxy
 * @see mvcexpress.extensions.unpuremvc.patterns.command.UnpureSimpleCommand SimpleCommand
 * @see mvcexpress.extensions.unpuremvc.patterns.command.UnpureMacroCommand MacroCommand
 *
 * @version unpuremvc.1.0.beta2
 */
public class UnpureFacade extends ModuleCore {

	//----------------------------------
	//	mvcExpress stuff
	//----------------------------------

	//public static const notificationNameStack:Vector.<String> = new <String>[];
	//public static const notificationTypeStack:Vector.<String> = new <String>[];


	/**
	 * Function to get rid of module.
	 * - All module commands are unmapped.
	 * - All module mediators are unmediated
	 * - All module proxies are unmapped
	 * - All internals are nulled.
	 */
	override public function disposeModule():void {
		super.disposeModule();
		instanceRegistry[moduleName] = null;
	}

	//----------------------------------
	//
	//	Pure MVC hacks
	//
	//----------------------------------

	static private var $proxyRegistry:Dictionary = new Dictionary();
	static private var $mediatorRegistry:Dictionary = new Dictionary();

	public function getModuleName():String {
		return moduleName;
	}

	/** @private */
	pureLegsCore function getMediatorMap():MediatorMap {
		return mediatorMap;
	}

	/** @private */
	pureLegsCore function getMessender():Messenger {
		use namespace pureLegsCore;

		return messenger;
	}

	/** @private */
	pureLegsCore function getProxyMap():ProxyMap {
		return proxyMap;
	}

	//----------------------------------
	//
	//	Pure MVC interface
	//
	//----------------------------------


	// Private references to Model, View and Controller
	protected var controller:UnpureController;
	protected var model:UnpureModel;
	protected var view:UnpureView;

	// The Singleton Facade instance.
	protected static var instanceRegistry:Dictionary = new Dictionary();

	// Message Constants
	protected const SINGLETON_MSG:String = "Facade Singleton already constructed!";
	protected const MULTITON_MSG:String = "Facade instance for this Multiton key already constructed!";

	private static var _instance:UnpureFacade;

	private static const SINGLE_CORE_NAME:String = "$_SINGLECORE_$";

	/**
	 * Constructor.
	 *
	 * <P>
	 * This <code>IFacade</code> implementation is a Singleton,
	 * so you should not call the constructor
	 * directly, but instead call the static Singleton
	 * Factory method <code>Facade.getInstance()</code>
	 *
	 * @throws Error Error if Singleton instance has already been constructed
	 *
	 */
	public function UnpureFacade(moduleName:String = null) {
		if (moduleName == null) {
			moduleName = SINGLE_CORE_NAME;
		}

		super(moduleName, null, null, UnpureCommandMap, UnpureMessenger);

		if (instanceRegistry[moduleName] != null) {
			if (moduleName == "") {
				throw Error(SINGLETON_MSG);
			} else {
				throw Error(MULTITON_MSG);
			}
		}
		instanceRegistry[moduleName] = this;

		// init module
		use namespace pureLegsCore;

		// init facade
		initializeFacade();

		// triger onInit
		onInit();
	}

	/**
	 * Initialize the Singleton <code>Facade</code> instance.
	 *
	 * <P>
	 * Called automatically by the constructor. Override in your
	 * subclass to do any subclass specific initializations. Be
	 * sure to call <code>super.initializeFacade()</code>, though.</P>
	 */
	protected function initializeFacade():void {

		$proxyRegistry[moduleName] = new Dictionary();
		$mediatorRegistry[moduleName] = new Dictionary()

		initializeModel();
		initializeController();
		initializeView();
	}

	/**
	 * UnpureFacade Singleton Factory method
	 *
	 * @return the Singleton instance of the Facade
	 */
	public static function getInstance(moduleName:String = null):UnpureFacade {
		if (moduleName == null) {
			moduleName = SINGLE_CORE_NAME;
		}
		if (instanceRegistry[moduleName] == null) {
			new UnpureFacade(moduleName);
			$proxyRegistry[moduleName] = new Dictionary();
			$mediatorRegistry[moduleName] = new Dictionary();
		}
		return instanceRegistry[moduleName];
	}

	static protected function get instance():UnpureFacade {
		return _instance;
	}

	static protected function set instance(value:UnpureFacade):void {
		_instance = value;

	}

	/**
	 * Initialize the <code>Controller</code>.
	 *
	 * <P>
	 * Called by the <code>initializeFacade</code> method.
	 * Override this method in your subclass of <code>Facade</code>
	 * if one or both of the following are true:
	 * <UL>
	 * <LI> You wish to initialize a different <code>IController</code>.</LI>
	 * <LI> You have <code>Commands</code> to register with the <code>Controller</code> at startup.</code>. </LI>
	 * </UL>
	 * If you don't want to initialize a different <code>IController</code>,
	 * call <code>super.initializeController()</code> at the beginning of your
	 * method, then register <code>Command</code>s.
	 * </P>
	 */
	protected function initializeController():void {
		if (controller != null) return;
		controller = UnpureController.getInstance(moduleName);
	}

	/**
	 * Initialize the <code>Model</code>.
	 *
	 * <P>
	 * Called by the <code>initializeFacade</code> method.
	 * Override this method in your subclass of <code>Facade</code>
	 * if one or both of the following are true:
	 * <UL>
	 * <LI> You wish to initialize a different <code>IModel</code>.</LI>
	 * <LI> You have <code>Proxy</code>s to register with the Model that do not
	 * retrieve a reference to the Facade at construction time.</code></LI>
	 * </UL>
	 * If you don't want to initialize a different <code>IModel</code>,
	 * call <code>super.initializeModel()</code> at the beginning of your
	 * method, then register <code>Proxy</code>s.
	 * <P>
	 * Note: This method is <i>rarely</i> overridden; in practice you are more
	 * likely to use a <code>Command</code> to create and register <code>Proxy</code>s
	 * with the <code>Model</code>, since <code>Proxy</code>s with mutable data will likely
	 * need to send <code>INotification</code>s and thus will likely want to fetch a reference to
	 * the <code>Facade</code> during their construction.
	 * </P>
	 */
	protected function initializeModel():void {
		if (model != null) return;
		model = UnpureModel.getInstance(moduleName);
	}


	/**
	 * Initialize the <code>View</code>.
	 *
	 * <P>
	 * Called by the <code>initializeFacade</code> method.
	 * Override this method in your subclass of <code>Facade</code>
	 * if one or both of the following are true:
	 * <UL>
	 * <LI> You wish to initialize a different <code>IView</code>.</LI>
	 * <LI> You have <code>Observers</code> to register with the <code>View</code></LI>
	 * </UL>
	 * If you don't want to initialize a different <code>IView</code>,
	 * call <code>super.initializeView()</code> at the beginning of your
	 * method, then register <code>IMediator</code> instances.
	 * <P>
	 * Note: This method is <i>rarely</i> overridden; in practice you are more
	 * likely to use a <code>Command</code> to create and register <code>Mediator</code>s
	 * with the <code>View</code>, since <code>IMediator</code> instances will need to send
	 * <code>INotification</code>s and thus will likely want to fetch a reference
	 * to the <code>Facade</code> during their construction.
	 * </P>
	 */
	protected function initializeView():void {
		if (view != null) return;
		view = UnpureView.getInstance(moduleName);
	}

	/**
	 * Register an <code>ICommand</code> with the <code>Controller</code> by Notification name.
	 *
	 * @param notificationName the name of the <code>INotification</code> to associate the <code>ICommand</code> with
	 * @param commandClassRef a reference to the Class of the <code>ICommand</code>
	 */
	public function registerCommand(notificationName:String, commandClassRef:Class):void {
		commandMap.map(notificationName, commandClassRef);
	}

	/**
	 * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
	 *
	 * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
	 */
	public function removeCommand(notificationName:String):void {
		commandMap.unmap(notificationName);
	}

	/**
	 * Check if a Command is registered for a given Notification
	 *
	 * @param notificationName
	 * @return whether a Command is currently registered for the given <code>notificationName</code>.
	 */
	public function hasCommand(notificationName:String):Boolean {
		return commandMap.isMapped(notificationName);
	}

	/**
	 * Register an <code>IProxy</code> with the <code>Model</code> by name.
	 *
	 * @param proxyName the name of the <code>IProxy</code>.
	 * @param proxy the <code>IProxy</code> instance to be registered with the <code>Model</code>.
	 */
	public function registerProxy(proxy:UnpureProxy):void {
		var proxyName:String = proxy.getProxyName();
		var oldProxy:Object = $proxyRegistry[moduleName][proxyName];
		if (oldProxy) {
			trace("Unpure error! : 2 proxies with same name!:" + proxyName + " Old proxy will be removed:" + $proxyRegistry[moduleName][proxyName] + ", new proxy:" + proxy);
			proxyMap.unmap(oldProxy.constructor, proxyName);
			$proxyRegistry[moduleName][proxyName] = null;
		}
		$proxyRegistry[moduleName][proxyName] = proxy;
		proxyMap.map(proxy, (proxy as Object).constructor, proxyName);
	}

	/**
	 * Retrieve an <code>UnpureProxy</code> from the <code>Model</code> by name.
	 *
	 * @param proxyName the name of the proxy to be retrieved.
	 * @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
	 */
	public function retrieveProxy(proxyName:String):UnpureProxy {
		return $proxyRegistry[moduleName][proxyName];
	}

	/**
	 * Remove an <code>IProxy</code> from the <code>Model</code> by name.
	 *
	 * @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
	 * @return the <code>IProxy</code> that was removed from the <code>Model</code>
	 */
	public function removeProxy(proxyName:String):UnpureProxy {
		var proxy:UnpureProxy = $proxyRegistry[moduleName][proxyName];
		//if (model != null) proxy = model.removeProxy(proxyName);
		if (proxy) {
			proxyMap.unmap((proxy as Object).constructor, proxyName);
			$proxyRegistry[moduleName][proxyName] = null;
		}
		return proxy;

	}

	/**
	 * Check if a Proxy is registered
	 *
	 * @param proxyName
	 * @return whether a Proxy is currently registered with the given <code>proxyName</code>.
	 */
	public function hasProxy(proxyName:String):Boolean {
		return ($proxyRegistry[moduleName][proxyName] != null);
	}

	/**
	 * Register a <code>IMediator</code> with the <code>View</code>.
	 *
	 * @param mediatorName the name to associate with this <code>IMediator</code>
	 * @param mediator a reference to the <code>IMediator</code>
	 */
	public function registerMediator(mediator:UnpureMediator):void {
		use namespace pureLegsCore;

		var mediatorName:String = mediator.getMediatorName();
		var oldMediator:UnpureMediator = $mediatorRegistry[moduleName][mediatorName];
		if (oldMediator) {
			trace("Unpure error! : 2 mediators with same name!:" + mediatorName + " Old mediator will be removed:" + oldMediator + ", new mediator:" + mediator);
			oldMediator.remove();
			$mediatorRegistry[moduleName][mediatorName] = null;
		}
		$mediatorRegistry[moduleName][mediatorName] = mediator;

		mediator.initMediator(moduleName);
		mediator.initNotificationHandling();
		mediator.register();
	}

	/**
	 * Retrieve an <code>IMediator</code> from the <code>View</code>.
	 *
	 * @param mediatorName
	 * @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
	 */
	public function retrieveMediator(mediatorName:String):UnpureMediator {
		return $mediatorRegistry[moduleName][mediatorName];
	}

	/**
	 * Remove an <code>IMediator</code> from the <code>View</code>.
	 *
	 * @param mediatorName name of the <code>IMediator</code> to be removed.
	 * @return the <code>IMediator</code> that was removed from the <code>View</code>
	 */
	public function removeMediator(mediatorName:String):UnpureMediator {
		use namespace pureLegsCore;

		var mediator:UnpureMediator = $mediatorRegistry[moduleName][mediatorName]
		if (mediator) {
			mediator.remove();
			$mediatorRegistry[moduleName][mediatorName] = null;
		}
		return mediator;
	}

	/**
	 * Check if a Mediator is registered or not
	 *
	 * @param mediatorName
	 * @return whether a Mediator is registered with the given <code>mediatorName</code>.
	 */
	public function hasMediator(mediatorName:String):Boolean {
		return ($mediatorRegistry[moduleName][mediatorName] != null);
	}

	/**
	 * Create and send an <code>INotification</code>.
	 *
	 * <P>
	 * Keeps us from having to construct new notification
	 * instances in our implementation code.
	 * @param notificationName the name of the notiification to send
	 * @param body the body of the notification (optional)
	 * @param type the type of the notification (optional)
	 */
	public function sendNotification(notificationName:String, body:Object = null, type:String = null):void {
		if (type) {
			throw Error("Sending type is not supported. Add it to body object.(refactore body and type into new object if needed.)");
		}
		sendMessage(notificationName, body);
	}

	/**
	 * Notify <code>Observer</code>s.
	 * <P>
	 * This method is left public mostly for backward
	 * compatibility, and to allow you to send custom
	 * notification classes using the facade.</P>
	 *<P>
	 * Usually you should just call sendNotification
	 * and pass the parameters, never having to
	 * construct the notification yourself.</P>
	 *
	 * @param notification the <code>INotification</code> to have the <code>View</code> notify <code>Observers</code> of.
	 */
	public function notifyObservers(notification:UnpureNotification):void {
		sendMessage(notification.getType(), notification);
	}

	/**
	 * Set the Multiton key for this facade instance.
	 * <P>
	 * Not called directly, but instead from the
	 * constructor when getInstance is invoked.
	 * It is necessary to be public in order to
	 * implement INotifier.</P>
	 */
	public function initializeNotifier(key:String):void {
		trace("Error?! Unpure extention does not handle this function. use UnpureFacade.getInstance(key) to set key(moduleName) instead.")
	}


	/**
	 * Check if a Core is registered or not
	 *
	 * @param key the multiton key for the Core in question
	 * @return whether a Core is registered with the given <code>key</code>.
	 */
	public static function hasCore(maduleName:String):Boolean {
		return (instanceRegistry[maduleName] != null);
	}

	/**
	 * Remove a Core.
	 * <P>
	 * Remove the Model, View, Controller and Facade
	 * instances for the given key.</P>
	 *
	 * @param multitonKey of the Core to remove
	 */
	public static function removeCore(maduleName:String):void {

		if (instanceRegistry[maduleName] == null) return;
		UnpureModel.removeModel(maduleName);
		UnpureView.removeView(maduleName);
		UnpureController.removeController(maduleName);

		instanceRegistry[maduleName].disposeModule()

		delete instanceRegistry[maduleName];
	}

	//------------------
	//  Hack functions to help refactoring.
	//------------------

	public function get hack_proxyMap():ProxyMap {
		return proxyMap;
	}

	public function get hack_mediatorMap():MediatorMap {
		return mediatorMap;
	}
}
}