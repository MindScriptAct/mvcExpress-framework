package suites.testObjects.moduleMain {
import mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class MainRemoteCommand extends Command {

	[Inject]
	public var dataProxy:MainDataProxy;

	public function execute(blank:Object):void {
		dataProxy.remoteCommandCount++;
	}

}
}