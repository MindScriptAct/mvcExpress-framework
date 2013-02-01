package integration.aGenericTestObjects.view {
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class GenericViewObjectMediator extends Mediator{
	
	[Inject]
	public var view:GenericViewObject;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void{
		
	}
	
	override public function onRemove():void{
		
	}
	
}
}