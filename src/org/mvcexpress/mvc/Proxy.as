// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Classes to hold application data.
 * Can send messages.
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class Proxy {
	
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	public function Proxy(){
	}
	
	/**
	 * Sends a message with optional params object.
	 * @param	type	type of the message for Commands and handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function and to handle functions.
 	 * @param	targetModuleNames	array of module names as strings, by default [MessageTarget.SELF] is used.<\br>
	 * 									To target all existing modules use : [MessageTarget.ALL]
	 */
	protected function sendMessage(type:String, params:Object = null, targetModuleNames:Array = null):void {
		pureLegsCore::messenger.send(type, params, targetModuleNames);
	}
	
	/**
	 * @private
	 */
	pureLegsCore function register():void {
		onRegister();
	}
	
	/**
	 * @private
	 */
	pureLegsCore function remove():void {
		onRemove();
	}
	
	/**
	 * Then proxy is map'ed with proxyMap this function is called.
	 */
	protected function onRegister():void {
		// for override
	}
	
	/**
	 * Then proxy is unmap'ed with proxyMap this function is called.
	 */
	protected function onRemove():void {
		// for override
	}

}
}