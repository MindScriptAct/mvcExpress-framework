package org.mvcexpress.messenger {
	
/**
 * Constants for sending message targets
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MessageTarget {
	
	/** 
	 * Message will target same module it was sent from. </br>
	 * If no target array is sent to sendMessage() function - MessageTarget.SELF is used as target by default. </br>
	 * If you use targetModules Array in sendMessage() - messages will be send ONLY to specified modules.
	 */
	static public const SELF:String = "$_self_$";
	
	/**
	 * Message will target all existing modules.
	 */
	static public const ALL:String = "$_all_$";
	
}
}