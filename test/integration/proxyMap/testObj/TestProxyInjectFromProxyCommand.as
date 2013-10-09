package integration.proxyMap.testObj {
import integration.aGenericTestObjects.model.GenericTestProxy;

import mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org)
 */
public class TestProxyInjectFromProxyCommand extends Command {

	[Inject]
	public var genericTestProxy:GenericTestProxy;

	public function execute(blank:Object):void {

	}

}
}