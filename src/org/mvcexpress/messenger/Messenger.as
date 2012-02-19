package org.mvcexpress.messenger {
import flash.utils.Dictionary;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Handles framework communications.
 * @author rbanevicius
 */
public class Messenger {
	
	static private var allowInstantiation:Boolean;
	
	static private var instance:Messenger;
	
	// keeps ALL MsgVO's in vectors by message type that they have to respond to.
	private var messageRegistry:Dictionary = new Dictionary(); /* of Vector.<MsgVO> by String */
	
	// keeps ALL MsgVO's in Dictionalies by message type, maped by handlers for fast disabling and dublicated handler checks.
	private var handlerRegistry:Dictionary = new Dictionary(); /* of Dictionary by String */
	
	public function Messenger() {
		if (!allowInstantiation) {
			throw Error("Messenger is a singleton class, use getInstance() instead");
		}
	}
	
	/**
	 * @private
	 */
	static pureLegsCore function getInstance():Messenger {
		if (instance == null) {
			allowInstantiation = true;
			instance = new Messenger();
			allowInstantiation = false;
		}
		return instance;
	}
	
	/**
	 * Adds handler function that will be called then message of specified type is sent.
	 * @param	type	message type to react to.
	 * @param	handler	function called on sent message, this function must have one and only one parameter.
	 * @return	returns message data object. This object can be disabled instead of removing the handle with function. (disabling is much faster)
	 */
	public function addHandler(type:String, handler:Function, handlerClassName:String = null):MsgVO {
		
		if (!messageRegistry[type]) {
			messageRegistry[type] = new Vector.<MsgVO>();
			handlerRegistry[type] = new Dictionary();
		}
		
		var msgData:MsgVO = handlerRegistry[type][handler];
		
		CONFIG::debug {
			if (msgData) {
				throw Error("This handler function is already mapped to message type :" + type);
			}
		}
		
		if (!msgData) {
			msgData = new MsgVO(handlerClassName);
			msgData.handler = handler;
			messageRegistry[type].push(msgData);
			handlerRegistry[type][handler] = msgData;
		}
		return msgData;
	}
	
	/**
	 * Removes handler function that will be called then message of specified type is sent.
	 * - if handler is not found it fails silently.
	 * @param	type	message type that handler had to react
	 * @param	handler	function called on sent message.
	 */
	public function removeHandler(type:String, handler:Function):void {
		if (handlerRegistry[type]) {
			if (handlerRegistry[type][handler]) {
				(handlerRegistry[type][handler] as MsgVO).disabled = true;
				delete handlerRegistry[type][handler];
			}
		}
	}
	
	// TODO : consider adding error checking that wil FIND this function if it fails.. (to say what mediator failed to handle the message...) debug mode only... (most likely will be slow.. but very helpfull for debug mode.)
	/**
	 * Runs all handler functions asociatod with message type, and send params object as single parameter.
	 * @param	type	message type to find needed handlers
	 * @param	params	parameter object that will be sent to all handler functions as single parameter.
	 */
	public function send(type:String, params:Object = null):void {
		var messageList:Vector.<MsgVO> = messageRegistry[type];
		var msgVo:MsgVO;
		var delCount:int = 0;
		if (messageList) {
			var tempListLength:int = messageList.length
			for (var i:int = 0; i < tempListLength; i++) {
				msgVo = messageList[i];
				// check if message is not marked to be removed. (disabled)
				if (msgVo.disabled) {
					delCount++;
				} else {
					// if some MsgVOs marked to be removed - move all other messages to there place.
					if (delCount) {
						messageList[i - delCount] = messageList[i];
					}
					// check if handling function handles commands.
					if (msgVo.isExecutable) {
						msgVo.handler(type, params);
					} else {
						CONFIG::debug {
							// FOR DEBUG viewing only..
							/* Failed message type: */
							type
							/* Failed handler class: */
							msgVo.handlerClassName
						}
						msgVo.handler(params);
					}
				}
			}
			// remove all removed handlers.
			if (delCount) {
				messageList.splice(tempListLength - delCount, delCount);
			}
		}
	}
	
	/**
	 * @private
	 */
	pureLegsCore function clear():void {
		messageRegistry = new Dictionary();
		handlerRegistry = new Dictionary()
	}
	
	/**
	 * function to add command execute functios.
	 * @private
	 */
	pureLegsCore function addCommandHandler(type:String, executeFunction:Function, handlerClassName:String = null):void {
		var executeMvgVo:MsgVO = addHandler(type, executeFunction, handlerClassName);
		executeMvgVo.isExecutable = true;
	}
}
}