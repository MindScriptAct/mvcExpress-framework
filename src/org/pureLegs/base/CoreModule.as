package org.pureLegs.base {
import flash.display.DisplayObjectContainer;
import org.pureLegs.core.CommandMap;
import org.pureLegs.core.MediatorMap;
import org.pureLegs.core.ModelMap;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.namespace.pureLegsCore;

/**
 * Core class of framework.
 * It inits framework and lets you set up your application. (or execute Cammands that will do it.)
 * TODO : Also you can create modular application by having more then one CoreModule subclass.
 * @author rbanevicius
 */
public class CoreModule {
	private var mainObject:DisplayObjectContainer;
	
	protected var modelMap:ModelMap;
	
	protected var mediatorMap:MediatorMap;
	
	protected var commandMap:CommandMap;
	
	private var messenger:Messenger;
	
	/**
	 * CONSTRUCTOR
	 * @param	mainObject	main object of your application. Should be set once with main module if you have more then one.
	 */
	public function CoreModule(mainObject:DisplayObjectContainer = null) {
		this.mainObject = mainObject;
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		
		modelMap = new ModelMap(messenger);
		mediatorMap = new MediatorMap(messenger, modelMap);
		commandMap = new CommandMap(messenger, modelMap, mediatorMap);
		
		onStartUp();
	}
	
	/**
	 * Function called after framework is initialized.
	 * Ment to be overriten.
	 */
	protected function onStartUp():void {
		// for override
	}
	
	/**
	 * Function to shut down Module.
	 *  All internals are disposed.
	 *  All mediators removed.
	 *  All models removed.
	 */
	public function shutDown():void {
		onShutDown();
		//
		use namespace pureLegsCore;
		//
		commandMap.dispose();
		mediatorMap.dispose();
		modelMap.dispose();
		
		mainObject = null;
		commandMap = null;
		mediatorMap = null;
		modelMap = null;
		messenger = null;
	}
	
	/**
	 * Function called before module is destroed.
	 * Ment to be overriten.
	 */	
	protected function onShutDown():void {
		// for override
	}
	
	/**
	 * Return main object of aplication.
	 * @return
	 */
	protected function getMainObject():DisplayObjectContainer {
		return this.mainObject;
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