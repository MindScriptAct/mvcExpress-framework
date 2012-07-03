// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.messenger {
	import org.mvcexpress.base.CommandMap;

/**
 * Framework internal value data for message handlers.
 * <p>
 * Has a flag to be disabled. If it is disabled it will be not called and removed with first message of needed type.
 * </p>
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MsgVO {
	
	/* FOR INTERNAL USE ONLY, function that handles message parameters, can be Mediator function or Command execute() function */
	public var handler:Function;
	
	/* FOR INTERNAL USE ONLY, marks message for removal. */
	public var disabled:Boolean;
	
	/* FOR INTERNAL USE ONLY, shows if message is handled by Cammand. */
	public var isExecutable:Boolean;	
	
	/* FOR INTERNAL USE ONLY, Stores CommandMap there message camed from, ussed to remove all messages then commandMap is disposed with module dispose()  */
	public var sourceCommandMap:CommandMap;
	
	/* Variable to store class there handler came from. (for debuging) */
	public var handlerClassName:String;
	
	/**
	 * FOR INTERNAL USE ONLY - Constructior 
	 * @param	sourceCommandMap	source CommandMap that added a message, if message handled by Command
	 */
	public function MsgVO(sourceCommandMap:CommandMap) {
		this.sourceCommandMap = sourceCommandMap;
	}

}
}