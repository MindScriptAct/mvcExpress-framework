package integration.proxyMap.testObj{
import integration.aGenericTestObjects.genericObjects.GenericTestProxy;
import org.mvcexpress.mvc.Command;
	
/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org)
 */
public class CestConstCommand extends Command {
	
	[Inject (constName="integration.proxyMap.testObj::TestConstObject.TEST_CONST_FOR_PROXY_INJECT")]
	public var genericTestProxy:GenericTestProxy;;
	
	public function execute(blank:Object):void {
		
	}
	
}
}