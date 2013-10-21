// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.messenger {

/**
 * Framework internal value data for message handlers.
 * HandlerVO is not removed instantly then handler is not needed, only marked for removal(by seting handler to null.).
 * @private
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class HandlerVO {

	/** FOR INTERNAL USE ONLY. function that handles message parameters, can be Mediator function or Command execute() function */
	public var handler:Function;

	/** FOR INTERNAL USE ONLY. shows if message is handled by Command. */
	public var isExecutable:Boolean;

	/** FOR INTERNAL USE ONLY. Variable to store class there handler came from. (for debugging only) */
	CONFIG::debug
	public var handlerClassName:String;

}
}