// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import org.mvcexpress.base.CommandMap;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Command, handles business logic of your application. 												</br>
 * Can send messages.
 * <b><p>
 * It MUST contain execute(params:Object) function. Parameter can be typed as you wish.
 * </p></b>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
dynamic public class Command {
	
	public var commandMap:CommandMap;
	public var mediatorMap:MediatorMap;
	public var proxyMap:ProxyMap;
	
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	/** @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean;	
	
	/** CONSTRUCTOR */
	public function Command() {
		CONFIG::debug {
			if (!pureLegsCore::canConstruct) {
				throw Error("Command:"+this+" can be constructed only by framework. If you want to execute it - map it to message with commandMap.map() and send a message, or execute it directly with commandMap.execute()")
			}
		}
	}
	
	/**
	 * Sends a message with optional params object.
	 * @param	type	type of the message for Commands and handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function and to handle functions.
	 * @param	targetAllModules	if true, will send message to all existing modules, by default message will be internal for current module only.
	 */
	protected function sendMessage(type:String, params:Object = null, targetAllModules:Boolean = false):void {
		use namespace pureLegsCore;
		messenger.send(type, params, targetAllModules);
	}
	
	
	// execute function is not meant to be overridden in mvcExpress.
	// Because I want commands to have custom parameter object - you have to manually create execute() function in your commands.
	/*
	public function execute(params:Object):void {
	}
	*/

}
}