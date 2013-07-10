package suites.testObjects.moduleExternal {
import flash.events.Event;
import mvcexpress.mvc.Mediator;
import suites.SuiteModuleNames;
import suites.TestViewEvent;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ExternalViewMediator extends Mediator {

	[Inject]
	public var view:ExternalView;

	[Inject]
	public var dataProxy:ExternalDataProxy;

	override public function onRegister():void {
		view.addEventListener(TestViewEvent.ADD_LOCAL_HANDLER, handleAddLocalHandler);
		view.addEventListener(TestViewEvent.ADD_REMOTE_HANDLER, handleAddRemoteHandler);
		view.addEventListener(TestViewEvent.REMOVE_LOCAL_HANDLER, handleRemoveLocalHandler);
		view.addEventListener(TestViewEvent.REMOVE_REMOTE_HANDLER, handleRemoveRemoteHandler);
	}

	override public function onRemove():void {
		view.removeEventListener(TestViewEvent.ADD_LOCAL_HANDLER, handleAddLocalHandler);
		view.removeEventListener(TestViewEvent.ADD_REMOTE_HANDLER, handleAddRemoteHandler);
		view.removeEventListener(TestViewEvent.REMOVE_LOCAL_HANDLER, handleRemoveLocalHandler);
		view.removeEventListener(TestViewEvent.REMOVE_REMOTE_HANDLER, handleRemoveRemoteHandler);
	}

	private function handleAddLocalHandler(event:TestViewEvent):void {
		addHandler(event.messageType, trigerLocalHandler);
	}

	private function handleAddRemoteHandler(event:TestViewEvent):void {
		addRemoteHandler(event.messageType, trigerRemoteHandler, SuiteModuleNames.MAIN_MODULE)
	}

	private function handleRemoveLocalHandler(event:TestViewEvent):void {
		removeHandler(event.messageType, trigerLocalHandler);
	}

	private function handleRemoveRemoteHandler(event:TestViewEvent):void {
		removeRemoteHandler(event.messageType, trigerRemoteHandler, SuiteModuleNames.MAIN_MODULE);
	}

	//----------------------------------
	//
	//----------------------------------
	private function trigerLocalHandler(params:Object):void {
		dataProxy.localHandlerCount++;
	}

	private function trigerRemoteHandler(params:Object):void {
		dataProxy.remoteHandlerCount++;
	}
}
}