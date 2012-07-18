package suites.featureProxyHost.testObjects.localObjects {
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class HostProxy extends Proxy {
	
	static public var instances:Vector.<Proxy>;
	
	public function HostProxy() {
		instances.push(this);
	}
	
	public function dataChange():void {
		sendMessage("proxyCommunicationTest");
	}
	
	override protected function onRegister():void {
	
	}
	
	override protected function onRemove():void {
	
	}

}
}