package suites.testObjects.main {
import org.mvcexpress.mvc.Command;
	
/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MainLocalCommand extends Command{
	
	[Inject]
	public var dataProxy:MainDataProxy;
	
	public function execute(blank:Object):void{
		dataProxy.localCommandCount++;
	}
	
}
}