package org.mvcexpress.messenger {

/**
 * Framework internal value data for message handlers.
 * <p>
 * Has a flag to be disabled. If it is disabled it will be not called and removed with first message of needed type.
 * </p>
 * @author rbanevicius
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