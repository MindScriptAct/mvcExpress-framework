package com.mindScriptAct.mvcExpressLiveVisualizer.model {
import com.mindScriptAct.mvcExpressLiveVisualizer.constants.ProvideIds;

import mvcexpress.dlc.live.mvc.ProxyLive;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class ColorDataProxy extends ProxyLive {

	private var testColor:TestColorVO = new TestColorVO();
	private var colorId:String;

	public function ColorDataProxy(colorId:String) {
		this.colorId = colorId;
	}

	override protected function onRegister():void {
		provide(testColor, ProvideIds.TESTDATA + "_" + this.colorId);

		//var uintData:uint = uint.MAX_VALUE - 100;
		//provide(uintData, "uint");
		//
		//var nrData:Number = 1.2;
		//provide(nrData, "nr");
		//
		//var intData:int = 1;
		//provide(intData, "int");
		//
		//
		//var boolData:Boolean = true;
		//provide(boolData, "bool");
		//
		//var stringData:String = "str";
		//provide(stringData, "str");
		//
		//provide(null, "null");

	}

	override protected function onRemove():void {

	}

}
}