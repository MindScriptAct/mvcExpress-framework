package integration.scopedProxy.testObj.moduleB {
import integration.scopedProxy.testObj.moduleA.ScopedTestProxy;
import mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author rbanevicius
 */
public class ScopedProxpyTestCommand extends Command{

	[Inject(scope="proxyScope")]
	public var myProxy:ScopedTestProxy;

	public function execute(testData:String):void{
		myProxy.storedData = testData;
	}

}
}