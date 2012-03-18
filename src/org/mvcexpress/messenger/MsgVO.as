// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.messenger {

/**
 * Framework internal value data for message handlers.
 * <p>
 * Has a flag to be disabled. If it is disabled it will be not called and removed with first message of needed type.
 * </p>
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MsgVO {
	
	public var handler:Function;
	
	public var disabled:Boolean;
	
	public var isExecutable:Boolean;	
	
	/* variable to store class there handler came from. (for debuging) */
	public var handlerClassName:String;
	
	public function MsgVO(handlerClassName:String = null) {
		this.handlerClassName = handlerClassName;
	}

}
}