package integration.commandPooling.testObj.controller {
import mvcexpress.mvc.PooledCommand;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class CommPoolingSimpleCommand extends PooledCommand {

	static public var test:String = "aoeuaoeu";

	static public var constructCount:int = 0;
	static public var executeCount:int = 0;

	//[Inject]
	//public var myProxy:MyProxy;

	public function CommPoolingSimpleCommand() {
		CommPoolingSimpleCommand.constructCount++;
		super();
	}

	public function execute(blank:Object):void {
		CommPoolingSimpleCommand.executeCount++;
	}

}
}