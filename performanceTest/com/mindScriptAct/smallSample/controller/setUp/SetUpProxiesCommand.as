package com.mindScriptAct.smallSample.controller.setUp {
import com.mindScriptAct.smallSample.model.SmallTestProxy;
import org.mvcexpress.mvc.Command;

public class SetUpProxiesCommand extends Command {
	
	public function execute(params:Object):void {
		trace( "SetUpProxiesCommand.execute > params : " + params );
		proxyMap.mapClass(SmallTestProxy);		
	}

}
}