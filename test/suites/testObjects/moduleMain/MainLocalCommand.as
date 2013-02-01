package suites.testObjects.moduleMain {
import org.mvcexpress.mvc.Command;
	
/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MainLocalCommand extends Command{
	
	[Inject]
	public var dataProxy:MainDataProxy;
	
	public function execute(blank:Object):void{
		dataProxy.localCommandCount++;
	}
	
}
}