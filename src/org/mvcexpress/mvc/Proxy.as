// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import org.mvcexpress.core.interfaces.IProxyMap;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceProxy_sendMessage;
import org.mvcexpress.MvcExpress;

/**
 * Proxy holds and manages application data, provide API to work with it. 				</br>
 * Can send messages. (Usually sends one with data update)								</br>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Proxy {
	
	// Shows if proxy is ready. Read only.
	private var _isReady:Boolean = false;
	
	/**
	 * Interface to work with proxies.
	 */
	protected var proxyMap:IProxyMap;
	
	// for comunication.
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	/** @private */
	pureLegsCore var pendingInjections:int = 0;
	
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
		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;
			var moduleName:String = messenger.moduleName;
			MvcExpress.debug(new TraceProxy_sendMessage(MvcTraceActions.PROXY_SENDMESSAGE, moduleName, this, type, params));
		}
		//
		messenger.send(type, params);
		//
		// clean up loging the action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceProxy_sendMessage(MvcTraceActions.PROXY_SENDMESSAGE_CLEAN, moduleName, this, type, params));
		}
	}
	
	/**
	 * Sends message to all existing modules.
	 * @param	type				message type to find needed handlers
	 * @param	params				parameter object that will be sent to all handler and execute functions as single parameter.
	 */
	protected function sendMessageToAll(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		messenger.sendToAll(type, params);
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
	
	//----------------------------------
	//     INTERNAL
	//----------------------------------
	
	/**
	 * sets proxyMap interface.
	 * @param	iProxyMap
	 * @private
	 */
	pureLegsCore function setProxyMap(iProxyMap:IProxyMap):void {
		this.proxyMap = iProxyMap;
	}

}
}