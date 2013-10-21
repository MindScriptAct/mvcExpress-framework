package suites.testObjects.controller {
import mvcexpress.mvc.Command;

import suites.testObjects.moduleMain.MainDataProxy;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class GetProxyTestCommand extends Command {

	[Inject]
	public var dataProxy:MainDataProxy;

	public function execute(proxyData:Object):void {
		dataProxy.testProxy = proxyMap.getProxy(proxyData.moduleClass, proxyData.moduleName);
	}

}
}