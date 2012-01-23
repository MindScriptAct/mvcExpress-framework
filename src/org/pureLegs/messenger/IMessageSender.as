package org.pureLegs.messenger {

/**
 * interface to send message.
 * @author rbanevicius
 */
 
public interface IMessageSender {
	function send(type:String, params:Object = null):void;
}
}