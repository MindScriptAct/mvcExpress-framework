package com.mindScriptAct.smallSample.controller.setup {
import com.mindScriptAct.smallSample.model.SmallTestProxy;
import org.mvcexpress.mvc.Command;

public class SetupProxiesCommand extends Command {
	
	public function execute(params:Object):void {
		trace( "SetUpProxiesCommand.execute > params : " + params );
		proxyMap.mapClass(SmallTestProxy);		
	}

}
}