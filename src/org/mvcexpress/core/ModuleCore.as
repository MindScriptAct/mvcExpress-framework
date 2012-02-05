package org.mvcexpress.core {
import flash.display.DisplayObjectContainer;
import org.mvcexpress.base.CommandMap;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Core class of framework.
 * <p>
 * It inits framework and lets you set up your application. (or execute Cammands that will do it.)
 * Also you can create modular application by having more then one CoreModule subclass.
 * </p>
 * @author rbanevicius
 */
public class ModuleCore {
	
	protected var proxyMap:ProxyMap;
	
	protected var mediatorMap:MediatorMap;
	
	protected var commandMap:CommandMap;
	
	private var messenger:Messenger;
	
	/**
	 * CONSTRUCTOR
	 * @param	mainObject	main object of your application. Should be set once with main module if you have more then one.
	 */
	public function ModuleCore() {
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		
		proxyMap = new ProxyMap(messenger);
		mediatorMap = new MediatorMap(messenger, proxyMap);
		commandMap = new CommandMap(messenger, proxyMap, mediatorMap);
		
		onInit();
	}
	
	/**
	 * Function called after framework is initialized.
	 * Ment to be overriten.
	 */
	protected function onInit():void {
		// for override
	}
	
	/**
	 * Function to get rid of module.
	 *  All internals are disposed.
	 *  All mediators removed.
	 *  All proxies removed.
	 */
	public function dispose():void {
		onDispose();
		//
		use namespace pureLegsCore;
		//
		commandMap.dispose();
		mediatorMap.dispose();
		proxyMap.dispose();
		
		commandMap = null;
		mediatorMap = null;
		proxyMap = null;
		messenger = null;
	}
	
	/**
	 * Function called before module is destroed.
	 * Ment to be overriten.
	 */
	protected function onDispose():void {
		// for override
	}
	
	/**
	 * Message sender.
	 * @param	type	type of the message. (Commands and handle functions must bu map to it to react.)
	 * @param	params	Object that will be send to Command execute() or to handle function as parameter.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		messenger.send(type, params);
	}

}
}