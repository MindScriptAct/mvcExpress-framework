package integration.proxyMap.testObj{
import integration.aGenericTestObjects.model.GenericTestProxy;
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org)
 */
public class TestContsViewMediator extends Mediator {
	
	[Inject]
	public var view:TestContsView;
	
	[Inject (constName="integration.proxyMap.testObj::TestConstObject.TEST_CONST_FOR_PROXY_INJECT")]
	public var genericTestProxy:GenericTestProxy;
	
	override public function onRegister():void {
		
	}
	
	override public function onRemove():void {
		
	}
	
}
}