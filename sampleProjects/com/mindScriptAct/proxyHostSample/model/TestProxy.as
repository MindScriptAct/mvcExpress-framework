package com.mindScriptAct.proxyHostSample.model {
import com.mindScriptAct.proxyHostSample.messages.DataMessage;
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class TestProxy extends Proxy implements IReadOnlyTestProxy {
	
	private var circleCount:int;
	
	public function TestProxy() {
	}
	
	override protected function onRegister():void {
	}
	
	override protected function onRemove():void {
	}
	
	public function increaseCircleCount():void {
		circleCount++;
		sendMessage(DataMessage.COUNTER_CHANGED);
	}
	
	public function getCount():int {
		return circleCount;
	}
}
}