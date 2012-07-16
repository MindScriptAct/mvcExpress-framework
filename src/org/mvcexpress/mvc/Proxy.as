// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import org.mvcexpress.core.ProxyMap;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;

/**
 * Proxy holds and manages application data, provide API to work with it. 				</br>
 * Can send messages. (Usually sends one with data update)								</br>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Proxy {
	
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	/** @private */
	pureLegsCore var pendingInjections:int = 0;
	
	private var _isReady:Boolean = false;
	
	pureLegsCore var hostModuleName:String;
	
	/** CONSTRUCTOR */
	public function Proxy() {
	}
	
	/**
	 * Sends a message with optional params object.
	 * @param	type	type of the message for Commands and handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		// send message to self.
		messenger.send(type, params);
		// send message to all remote modules.. (but only if all modules are not already targeted.)
		if (hostModuleName != null) {
			messenger.sendTo(type, params, ProxyMap.getRemoteMudules(this));
		}
	}
	
	/**
	 * marks mediator as ready and calls onRegister()
	 * called from proxyMap
	 * @private
	 */
	pureLegsCore function register():void {
		if (!_isReady) {
			_isReady = true;
			onRegister();
		} else {
			throw Error("Proxy:" + this + " is already registered. You can register one proxy only once.");
		}
	}
	
	/**
	 * marks mediator as not ready and calls onRemove().
	 * called from proxyMap
	 * @private
	 */
	pureLegsCore function remove():void {
		_isReady = false;
		onRemove();
	}
	
	/**
	 * Then proxy is mapped with proxyMap this function is called.
	 */
	protected function onRegister():void {
		// for override
	}
	
	/**
	 * Then proxy is unmapped with proxyMap this function is called.
	 */
	protected function onRemove():void {
		// for override
	}
	
	/**
	 * Indicates if proxy is ready for usage. (all dependencies are injected.)
	 */
	protected function get isReady():Boolean {
		return _isReady;
	}

}
}