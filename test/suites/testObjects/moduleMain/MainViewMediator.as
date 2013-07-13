package suites.testObjects.moduleMain {
import mvcexpress.mvc.Mediator;

import suites.TestViewEvent;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MainViewMediator extends Mediator {

	[Inject]
	public var view:MainView;

	[Inject]
	public var dataProxy:MainDataProxy;

	override protected function onRegister():void {
		view.addEventListener(TestViewEvent.ADD_LOCAL_HANDLER, handleAddLocalHandler);
		//view.addEventListener(TestViewEvent.ADD_REMOTE_HANDLER, handleAddRemoteHandler);
		view.addEventListener(TestViewEvent.REMOVE_LOCAL_HANDLER, handleRemoveLocalHandler);
		//view.addEventListener(TestViewEvent.REMOVE_REMOTE_HANDLER, handleRemoveRemoteHandler);
		view.addEventListener(TestViewEvent.TEST_GET_PROXY_CLASS, handleTestProxyGetHandler);

	}

	override protected function onRemove():void {
		view.removeEventListener(TestViewEvent.ADD_LOCAL_HANDLER, handleAddLocalHandler);
		//view.removeEventListener(TestViewEvent.ADD_REMOTE_HANDLER, handleAddRemoteHandler);
		view.removeEventListener(TestViewEvent.REMOVE_LOCAL_HANDLER, handleRemoveLocalHandler);
		//view.removeEventListener(TestViewEvent.REMOVE_REMOTE_HANDLER, handleRemoveRemoteHandler);
		view.removeEventListener(TestViewEvent.TEST_GET_PROXY_CLASS, handleTestProxyGetHandler);
	}

	private function handleAddLocalHandler(event:TestViewEvent):void {
		addHandler(event.messageType, trigerLocalHandler);
	}

	//private function handleAddRemoteHandler(event:TestViewEvent):void {
	//addRemoteHandler(event.messageType, trigerRemoteHandler, SuiteModuleNames.EXTERNAL_MODULE)
	//}

	private function handleRemoveLocalHandler(event:TestViewEvent):void {
		removeHandler(event.messageType, trigerLocalHandler);
	}

	//private function handleRemoveRemoteHandler(event:TestViewEvent):void {
	//removeRemoteHandler(event.messageType, trigerRemoteHandler, SuiteModuleNames.EXTERNAL_MODULE);
	//}

	private function handleTestProxyGetHandler(event:TestViewEvent):void {
		// event.messageType used as module name !!
		dataProxy.testProxy = proxyMap.getProxy(event.testClass, event.messageType);
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