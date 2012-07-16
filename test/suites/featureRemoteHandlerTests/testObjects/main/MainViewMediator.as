package suites.featureRemoteHandlerTests.testObjects.main {
import flash.events.Event;
import org.mvcexpress.mvc.Mediator;
import suites.ViewTestEvents;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MainViewMediator extends Mediator {
	
	[Inject]
	public var view:MainView;
	
	[Inject]
	public var dataProxy:MainDataProxy;
	
	override public function onRegister():void {
		view.addEventListener(ViewTestEvents.ADD_LOCAL_HANDLER, handleAddLocalHandler);
		view.addEventListener(ViewTestEvents.ADD_REMOTE_HANDLER, handleAddRemoteHandler);
	}
	
	override public function onRemove():void {
		view.removeEventListener(ViewTestEvents.ADD_LOCAL_HANDLER, handleAddLocalHandler);
		view.removeEventListener(ViewTestEvents.ADD_REMOTE_HANDLER, handleAddRemoteHandler);
	}
	
	private function handleAddLocalHandler(event:Event):void {
		dataProxy.localHandlerCount++;
	}
	
	private function handleAddRemoteHandler(event:Event):void {
		dataProxy.remoteHandlerCount++;
	}
}
}