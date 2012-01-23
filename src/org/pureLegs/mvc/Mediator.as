package org.pureLegs.mvc {
import org.pureLegs.core.MediatorMap;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.messenger.MsgVO;
import org.pureLegs.namespace.pureLegsCore;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Mediator {
	
	private var messageDataRegistry:Vector.<MsgVO> = new Vector.<MsgVO>();
	
	pureLegsCore var messanger:Messenger;
	
	public var mediatorMap:MediatorMap;
	
	public function onRegister():void {
	}
	
	public function onRemove():void {
	}
	
	protected function sendMessage(type:String, body:Object = null):void {
		pureLegsCore::messanger.send(type, body);
	}
	
	protected function addHandler(message:String, handler:Function):void {
		messageDataRegistry.push(pureLegsCore::messanger.addHandler(message, handler));
	}
	
	protected function removeCallback(type:String, handler:Function):void {
		pureLegsCore::messanger.removeHandler(type, handler);
	}
	
	pureLegsCore function destroyCallbacks():void {
		for (var i:int = 0; i < messageDataRegistry.length; i++) {
			messageDataRegistry[i].disabled = true;
		}
		messageDataRegistry = null;
	}

}
}