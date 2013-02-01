package com.mindScriptAct.mvcExpressLiveVisualizer.controller {
import com.mindScriptAct.mvcExpressLiveVisualizer.model.ColorDataProxy;
import org.mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class AddTestProxyCommand extends Command {
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	public function execute(colorId:String):void {
		proxyMap.map(new ColorDataProxy(colorId), null, colorId);
	}

}
}