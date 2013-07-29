package mvcexpress.dlc.unpuremvc.unpureCommandMap {
import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.dlc.unpuremvc.patterns.facade.UnpureFacade;
import mvcexpress.dlc.unpuremvc.patterns.observer.UnpureNotification;
import mvcexpress.utils.checkClassSuperclass;

use namespace pureLegsCore;

public class UnpureCommandMap extends CommandMap {

	public function UnpureCommandMap($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap, $mediatorMap:MediatorMap) {
		super($moduleName, $messenger, $proxyMap, $mediatorMap);
	}


	// TODO : fix comunication..

	override pureLegsCore function handleCommandExecute(messageType:String, params:Object):void {

//		if (checkClassSuperclass(commandClass, "mvcexpress.dlc.unpuremvc.patterns.command::UnpureSimpleCommand")
//				||
//				checkClassSuperclass(commandClass, "mvcexpress.dlc.unpuremvc.patterns.command::UnpureMacroCommand")
//				||
//				getQualifiedClassName(commandClass) == "mvcexpress.dlc.unpuremvc.patterns.observer.observerCommand::UnpureObserverCommand"
//				) {
			params = new UnpureNotification(UnpureFacade.notificationNameStack[UnpureFacade.notificationNameStack.length - 1], params, UnpureFacade.notificationTypeStack[UnpureFacade.notificationTypeStack.length - 1]);
//		}

		super.pureLegsCore::handleCommandExecute(messageType, params);
	}

//	override pureLegsCore function handleCommandExecute(messageType:String, params:Object):void {
//		super.pureLegsCore::handleCommandExecute(messageType, params);
//	}
}
}
