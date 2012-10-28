package integration.commandPooling {
import flexunit.framework.Assert;
import integration.commandPooling.testObj.CommandPoolingModule;
import integration.mediating.testObj.*;
import integration.mediating.testObj.view.*;
import integration.mediating.testObj.view.viewObj.*;
import org.mvcexpress.core.*;


public class CommandPoolingTests {
	private var commandPoolingModule:CommandPoolingModule;
	private var commandPoolModuleCommandMap:CommandMap;;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		commandPoolingModule = new CommandPoolingModule();
		commandPoolModuleCommandMap = commandPoolingModule.getCommandMap();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		commandPoolModuleCommandMap = null;
		commandPoolingModule.disposeModule();
		commandPoolingModule = null;
	}
	
	[Test]
	
	public function commandPooling_cashingCammandUsedTwice_constructedOnce():void {
		//commandPoolModuleCommandMap.map(
		//
		//
		//mediatorMap.map(MediatingSubView, MediatingSuperClassMediator, MediatingBaseView);
		//var view:MediatingSubView = new MediatingSubView();
		//mediatorMap.mediate(view);
		//Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingBaseView.timesRegistered);
	}

}
}