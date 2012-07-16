package suites.featureRemoteHandlerTests.testObjects.main {
import org.mvcexpress.mvc.Command;
	
/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MainRemoteCommand extends Command{
	
	[Inject]
	public var dataProxy:MainDataProxy;
	
	public function execute(blank:Object):void{
		dataProxy.remoteCommandCount++;
	}
	
}
}