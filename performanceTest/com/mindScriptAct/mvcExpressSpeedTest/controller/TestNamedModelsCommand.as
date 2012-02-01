package com.mindScriptAct.mvcExpressSpeedTest.controller {
import com.mindScriptAct.mvcExpressSpeedTest.model.INamedModel;
import com.mindScriptAct.mvcExpressSpeedTest.model.NamedModel;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class TestNamedModelsCommand extends Command {
	
	[Inject(name="namedModel_1")]
	public var namedModel1:NamedModel;
	
	[Inject(name="namedModel_2")]
	public var namedModel2:NamedModel;
	
	[Inject]
	public var namedModel_interface:INamedModel;
	
	[Inject]
	public var namedModel_Singleton:NamedModel;
	
	[Inject(name="namedSingletonInterface")]
	public var namedModel_Singleton_interface:INamedModel;
	
	public function execute(params:Object):void {
		trace("TestNamedModelsCommand.execute > params : " + params);
		trace(namedModel_interface.getSomeData());
	}

}
}