package suites.commandMap.commands {
import flash.display.Sprite;
import org.pureLegs.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class TestCommand1 extends Command {
	
	static public var TEST_FUNCTION:Function = function(msg:*):void {
		//trace("TestCommand1 executed...")
	};
	
	public function execute(params:Object):void {
		//trace("TestCommand1.execute > msg : " + msg);
		TestCommand1.TEST_FUNCTION(params);
	}

}
}