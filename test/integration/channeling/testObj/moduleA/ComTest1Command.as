package integration.channeling.testObj.moduleA {
import org.mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ComTest1Command extends Command {
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	public function execute(moduleA:ChannelModuleA):void {
		moduleA.command1executed = true;
	}

}
}