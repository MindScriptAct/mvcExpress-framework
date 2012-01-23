package org.pureLegs.base {
import org.pureLegs.core.CommandMap;
import org.pureLegs.core.MediatorMap;
import org.pureLegs.core.ModelMap;
import org.pureLegs.messenger.Messenger;

/**
 * COMMENT
 * @author rbanevicius
 */
public class CoreModule {
	
	protected var commandMap:CommandMap;
	
	protected var modelMap:ModelMap;
	
	protected var mediatorMap:MediatorMap;
	
	private var messenger:Messenger;
	
	public function CoreModule() {
		
		messenger = new Messenger();
		
		modelMap = new ModelMap(messenger);
		mediatorMap = new MediatorMap(messenger, modelMap);
		commandMap = new CommandMap(messenger, modelMap, mediatorMap);
		
		startup();
	}
	
	public function startup():void {
		// for overide
	}
	
	protected function sendMessage(type:String, body:Object = null):void {
		messenger.send(type, body);
	}

	//protected function addCallback(message:String, callBackFunction:Function):void {
	//messageDataRegistry.push(pureLegsCore::
	//messenger.addCallback(message, callBackFunction)
	//);
	//}
	//
	//protected function removeCallback(type:String, callBack:Function):void {
	//messenger.removeCallback(type, callBack);
	//for (var i:int = 0; i < messageDataRegistry.length; i++) {
	//if (messageDataRegistry[i].callBack == callBack && messageDataRegistry[i].type == type) {
	//messageDataRegistry[i].disabled = true;
	//messageDataRegistry.splice(i, 1);
	//}
	//}
	//}

}
}