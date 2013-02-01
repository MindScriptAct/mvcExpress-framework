package suites.testObjects.controller {
import org.mvcexpress.mvc.Command;
import suites.testObjects.moduleMain.MainDataProxy;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class GetProxyTestCommand extends Command {
	
	[Inject]
	public var dataProxy:MainDataProxy;
	
	public function execute(proxyData:Object):void {
		dataProxy.testProxy = proxyMap.getProxy(proxyData.moduleClass, proxyData.moduleName);
	}

}
}