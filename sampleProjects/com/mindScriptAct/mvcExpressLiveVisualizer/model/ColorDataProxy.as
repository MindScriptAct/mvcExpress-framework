package com.mindScriptAct.mvcExpressLiveVisualizer.model {
import com.mindScriptAct.mvcExpressLiveVisualizer.constants.ProvideIds;
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class ColorDataProxy extends Proxy {
	
	private var testColor:TestColorVO = new TestColorVO();
	
	public function ColorDataProxy() {
	
	}
	
	override protected function onRegister():void {
		provide(testColor, ProvideIds.TESTDATA);
	}
	
	override protected function onRemove():void {
	
	}

}
}