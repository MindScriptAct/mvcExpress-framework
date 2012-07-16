package suites.featureRemoteHandlerTests.testObjects.external {
import org.mvcexpress.mvc.Command;
	
/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ExternalRemoteCommand extends Command{
	
	[Inject]
	public var dataProxy:ExternalDataProxy;
	
	public function execute(blank:Object):void{
		dataProxy.remoteCommandCount++;
	}
	
}
}