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
	static public const TEST_GET_PROXY_CLASS:String = "testGetProxyClass";
	
	public var messageType:String;
	public var testClass:Class;
	
	public function TestViewEvent(type:String, messageType:String = null, testClass:Class = null) {
		super(type);
		this.testClass = testClass;
		this.messageType = messageType;
	}

}
}