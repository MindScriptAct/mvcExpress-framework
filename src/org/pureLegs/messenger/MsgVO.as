package org.pureLegs.messenger {

/**
 * Value data for message handler.
 * has a flag to be disabled. If it is disabled it will be not called and removed with first message of needed type.
 * @author rbanevicius
 */
public class MsgVO {
	
	public var handler:Function;
	
	public var disabled:Boolean;
	
	public function MsgVO(handler:Function){
		this.handler = handler;
	}

}
}