package integration.commandPooling.testObj.controller {
import org.mvcexpress.mvc.PooledCommand;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class CommPoolingUnlockedCommand extends PooledCommand {
	
	static public var test:String = "aoeuaoeu";
	
	static public var constructCount:int = 0;
	static public var executeCount:int = 0;
	
	public function CommPoolingUnlockedCommand() {
		CommPoolingUnlockedCommand.constructCount++;
		super();
	}
	
	public function execute(blank:Object):void {
		CommPoolingUnlockedCommand.executeCount++;
		unlock();
	}

}
}