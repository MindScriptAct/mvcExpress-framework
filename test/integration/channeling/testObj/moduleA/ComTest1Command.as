package integration.channeling.testObj.moduleA {
import integration.channeling.testObj.moduleB.ChannelModuleB;
import org.mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ComTest1Command extends Command {
	
	//[Inject]
	//public var myProxy:MyProxy;
	
public function execute(moduleB:ChannelModuleB):void {
		moduleB.command1executed = true;
	}

}
}