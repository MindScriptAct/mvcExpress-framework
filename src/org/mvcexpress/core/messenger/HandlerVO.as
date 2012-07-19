// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.messenger {

/**
 * Framework internal value data for message handlers.
 * <p>
 * Has a flag to be disabled. If it is disabled it will be not called and removed with first message of same type.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class HandlerVO {
	
	/** FOR INTERNAL USE ONLY. function that handles message parameters, can be Mediator function or Command execute() function */
	// TODO : investigate if stored handler is good candidate for memory leak scenarios.
	// (HandlerVO is not removed instantly, only marked for removal. It is removed only with next message call of needed type, this message not always comes. :\ )
	public var handler:Function;
	
	/** FOR INTERNAL USE ONLY. shows if message is handled by Command. */
	public var isExecutable:Boolean;
	
	/** FOR INTERNAL USE ONLY. Variable to store class there handler came from. (for debugging) */
	public var handlerClassName:String;

}
}