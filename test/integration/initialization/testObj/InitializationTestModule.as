package integration.initialization.testObj {
import integration.aGenericTestObjects.constants.GenericScopeIds;
import integration.aGenericTestObjects.constants.GenericTestMessage;
import integration.aGenericTestObjects.controller.GenericCommand;
import integration.aGenericTestObjects.model.GenericTestProxy;
import integration.aGenericTestObjects.view.GenericViewObject;
import integration.aGenericTestObjects.view.GenericViewObjectMediator;

import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;

import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;

import mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class InitializationTestModule extends ModuleCore {

	static public var testType:int;

	public static const PERMISION_TEST:int = 1;
	static public const CONTROLLER_TEST:int = 2;
	static public const PROXY_TEST:int = 3;
	static public const MEDIATOR_TEST:int = 4;

	public function InitializationTestModule() {
		super("InitializationTestModule");
	}


	//----------------------------------
	//     initialization
	//----------------------------------


	override protected function initializeMessenger():void {
		use namespace pureLegsCore;
		messenger = new Messenger();
		if (testType == PERMISION_TEST) {
		 	registerScope(GenericScopeIds.TEST_SCOPE);
		}
	}

	override protected function initializeController():void {
		commandMap = new CommandMap();
		if (testType == CONTROLLER_TEST) {
			commandMap.map(GenericTestMessage.TEST_MESSAGE, GenericCommand);
		}
	}

	override protected function initializeModel():void {
		proxyMap = new ProxyMap();
		if (testType == PROXY_TEST) {
			proxyMap.map(new GenericTestProxy());
		}

	}

	override protected function initializeView():void {
		mediatorMap = new MediatorMap();
		if (testType == MEDIATOR_TEST) {
			mediatorMap.map(GenericViewObject, GenericViewObjectMediator);
		}
	}

	public function checkCommandMap():Boolean {
		return commandMap.isMapped(GenericTestMessage.TEST_MESSAGE);
	}

	public function checkProxyMap():Boolean {
		return proxyMap.isMapped(GenericTestProxy);
	}

	public function checkMediatorMap():Boolean {
	 	return mediatorMap.isMapped(GenericViewObject);
	}
}
}