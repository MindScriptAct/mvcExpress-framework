package integration.proxyMap.testObj{
import integration.aGenericTestObjects.model.GenericTestProxy;
import mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org)
 */
public class CestConstCommand extends Command {

	[Inject (constName="integration.proxyMap.testObj::TestConstObject.TEST_CONST_FOR_PROXY_INJECT")]
	public var genericTestProxy:GenericTestProxy;;

	public function execute(blank:Object):void {

	}

}
}