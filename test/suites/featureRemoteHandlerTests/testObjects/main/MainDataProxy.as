package suites.featureRemoteHandlerTests.testObjects.main {
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MainDataProxy extends Proxy {
	
	public var localCommandCount:int = 0;
	public var localHandlerCount:int = 0;
	public var remoteCommandCount:int = 0;
	public var remoteHandlerCount:int = 0;
	
	public function MainDataProxy() {
	
	}
	
	override protected function onRegister():void {
	
	}
	
	override protected function onRemove():void {
	
	}

}
}