package suites.commandMap.commands {
import mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class TestCommand1 extends Command {

	static public var TEST_FUNCTION:Function = function (msg:*):void {
		//trace("TestCommand1 executed...")
	};

	public function execute(params:Object):void {
		//trace("TestCommand1.execute > params : " + params);
		TestCommand1.TEST_FUNCTION(params);
	}

}
}