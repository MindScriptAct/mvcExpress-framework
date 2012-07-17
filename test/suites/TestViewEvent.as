package suites {
import flash.events.Event;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class TestViewEvent extends Event {
	
	static public const ADD_LOCAL_HANDLER:String = "addLocalHandler";
	static public const ADD_REMOTE_HANDLER:String = "addRemoteHandler";
	static public const TRIGER_ADD_HANDLER:String = "trigerAddHandler";
	static public const REMOVE_LOCAL_HANDLER:String = "removeLocalHandler";
	static public const REMOVE_REMOTE_HANDLER:String = "removeRemoteHandler";
	
	public var messageType:String;
	
	public function TestViewEvent(type:String, messageType:String = null) {
		super(type);
		this.messageType = messageType;
	}

}
}