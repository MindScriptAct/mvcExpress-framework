package suites.testObjects.controller {
import org.mvcexpress.mvc.Command;
import suites.testObjects.main.MainDataProxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class GetProxyTestCommand extends Command {
	
	[Inject]
	public var dataProxy:MainDataProxy;
	
	public function execute(proxyClass:Class):void {
		dataProxy.testProxy = proxyMap.getProxy(proxyClass);
	}

}
}