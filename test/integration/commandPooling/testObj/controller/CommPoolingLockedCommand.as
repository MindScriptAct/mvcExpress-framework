package integration.commandPooling.testObj.controller {
import mvcexpress.mvc.PooledCommand;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class CommPoolingLockedCommand extends PooledCommand {

	static public var test:String = "aoeuaoeu";

	static public var constructCount:int = 0;
	static public var executeCount:int = 0;

	public function CommPoolingLockedCommand() {
		CommPoolingLockedCommand.constructCount++;
		super();
	}

	public function execute(blank:Object):void {
		CommPoolingLockedCommand.executeCount++;
		lock();
	}

}
}