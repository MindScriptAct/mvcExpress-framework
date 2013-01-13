package com.mindScriptAct.mvcExpressLiveVisualizer.model{
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class ProcessInjectProxy extends Proxy {
	
	
	private var _testData:String = "same teeest data...";
	
	public function ProcessInjectProxy() {
		
	}
	
	override protected function onRegister():void {
	
	}
	
	override protected function onRemove():void {
	
	}
	
	public function get testData():String {
		return _testData;
	}

}
}