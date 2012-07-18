package com.mindScriptAct.modules.counter.view {
import com.mindScriptAct.modules.counter.CounterModule;
import com.mindScriptAct.modules.interfaces.testProxy.IReadOnlyTestProxy;
import com.mindScriptAct.proxyHostSample.messages.DataMessage;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class CounterModuleMediator extends Mediator {
	
	[Inject]
	public var view:CounterModule;
	
	[Inject(isHosted=true)]
	public var testProxy:IReadOnlyTestProxy;
	
	override public function onRegister():void {
		addHandler(DataMessage.COUNTER_CHANGED, handleCounterChange);
	}
	
	public function handleCounterChange(blank:Object):void {
		trace("CounterModuleMediator.handleCounterChange > blank : " + blank);
		view.outputText.text = "Count:" + testProxy.getCount();
	}
	
	override public function onRemove():void {
	
	}

}
}