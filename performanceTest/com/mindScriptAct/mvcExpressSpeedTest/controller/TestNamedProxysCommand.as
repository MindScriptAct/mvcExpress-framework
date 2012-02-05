package com.mindScriptAct.mvcExpressSpeedTest.controller {
import com.mindScriptAct.mvcExpressSpeedTest.model.INamedProxy;
import com.mindScriptAct.mvcExpressSpeedTest.model.NamedProxy;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class TestNamedProxysCommand extends Command {
	
	[Inject(name="namedProxy_1")]
	public var namedProxy1:NamedProxy;
	
	[Inject(name="namedProxy_2")]
	public var namedProxy2:NamedProxy;
	
	[Inject]
	public var namedProxy_interface:INamedProxy;
	
	[Inject]
	public var namedProxy_Singleton:NamedProxy;
	
	[Inject(name="namedSingletonInterface")]
	public var namedProxy_Singleton_interface:INamedProxy;
	
	public function execute(params:Object):void {
		trace("TestNamedProxysCommand.execute > params : " + params);
		trace(namedProxy_interface.getSomeData());
	}

}
}