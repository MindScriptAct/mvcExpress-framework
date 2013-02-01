package suites.testObjects.moduleExternal {
import org.mvcexpress.mvc.Command;
	
/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ExternalLocalCommand extends Command{
	
	[Inject]
	public var dataProxy:ExternalDataProxy;
	
	public function execute(blank:Object):void{
		dataProxy.localCommandCount++;
	}
	
}
}