package com.mindScriptAct.mvcExpressVisualizer.model {
import com.mindScriptAct.mvcExpressVisualizer.messages.Message;
import org.mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestProxyA extends Proxy{
	
	public function TestProxyA(){
		
	}
	
	public function changeSomething():void {
		sendMessage(Message.TEST_PROXY_TO_MEDIATOR);
	}
	
	override protected function onRegister():void{
	
	}
	
	override protected function onRemove():void{
	
	}

}
}