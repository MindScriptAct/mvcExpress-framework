package suites.commandMap.commands {
import org.pureLegs.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class TestCommand2 extends Command {
	
	static public var TEST_FUNCTION:Function = function(msg:*):void {
		//trace("TestCommand2 executed...")
	};
	
	public function execute(params:Object):void {
		//trace("TestCommand2.execute > msg : " + msg);
		TestCommand2.TEST_FUNCTION(params);
		
	}

}
}