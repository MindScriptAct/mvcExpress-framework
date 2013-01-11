package com.mindScriptAct.mvcExpressLiveVisualizer.controller {
import com.mindScriptAct.mvcExpressLiveVisualizer.model.ColorDataProxy;
import org.mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class RemoveTestProxyCommand extends Command {
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	public function execute(blank:Object):void {
		proxyMap.unmap(ColorDataProxy);
	}

}
}