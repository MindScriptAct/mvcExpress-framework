package com.mindScriptAct.pureLegsSample {
import com.gskinner.performance.PerformanceTest;
import com.mindScriptAct.pureLegsSample.controller.params.ComplexParams;
import com.mindScriptAct.pureLegsSample.controller.SampleCommand;
import com.mindScriptAct.pureLegsSample.messages.Msg;
import com.mindScriptAct.pureLegsSample.model.ISampleEmptyModel;
import com.mindScriptAct.pureLegsSample.model.ISampleModel;
import com.mindScriptAct.pureLegsSample.model.SampleEmptyModel;
import com.mindScriptAct.pureLegsSample.model.SampleModel;
import com.mindScriptAct.pureLegsSample.view.SampleAppMediator;
import flash.display.Sprite;
import org.pureLegs.base.CoreModule;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleAppModule extends CoreModule {
	private var performanceTest:PerformanceTest;
	private var coreInitTime:int;
	private var mainView:PureLegsSample;
	
	public function SampleAppModule(mainView:PureLegsSample) {
		////////////////////////////
		// Store mainView for later use.
		////////////////////////////
		this.mainView = mainView;
		super();
	
	}
	
	////////////////////////////
	// Function called then framework is started and ready for work.
	////////////////////////////
	override protected function onStartUp():void {
		trace("SampleAppModule.onStartup");
		
		////////////////////////////
		// Model
		// - can be maped as already constucted object or class. Class will be automaticaly instantiated.
		// - models are mapet to injectClass+name. if dublication occure error is thrown.
		// - order is important if one model uses enother model.
		////////////////////////////
		
		modelMap.mapObject(new SampleEmptyModel("Simple model"));
		modelMap.mapObject(new SampleEmptyModel("Interfaced model"), ISampleEmptyModel);
		modelMap.mapObject(new SampleEmptyModel("Named model"), SampleEmptyModel, "namedSampleModel");
		modelMap.mapObject(new SampleEmptyModel("Named and interfaced model"), ISampleEmptyModel, "namedSampleInterfacedModel");
		
		modelMap.mapClass(SampleModel);
		modelMap.mapClass(SampleModel, ISampleModel);
		modelMap.mapClass(SampleModel, SampleModel, "testType");
		modelMap.mapClass(SampleModel, ISampleModel, "interfaceModel");
		
		////////////////////////////
		// View
		// - view classes are maped to mediator classes 1 to 1.
		////////////////////////////
		
		mediatorMap.map(PureLegsSample, SampleAppMediator);

		//mediatorMap.unmapMediator(PureLegsSample);
		
		
		////////////////////////////
		// controller
		////////////////////////////
		commandMap.map(Msg.TEST, SampleCommand);
		//commandMap.unmap(Msg.TEST, SampleCommand);
		
		commandMap.execute(SampleCommand);
		commandMap.execute(SampleCommand, "single execute parameter");
		commandMap.execute(SampleCommand, new ComplexParams("complex execute parameters"));
		
		////////////////////////////
		// comunication
		////////////////////////////
		sendMessage(Msg.TEST);
		sendMessage(Msg.TEST, "single message parameter");
		sendMessage(Msg.TEST, new ComplexParams("complex message parameters"));
		
		
		////////////////////////////
		// start application...
		// - mediate mainView object AND
		// - execute commands OR send messages
		////////////////////////////
		
		mediatorMap.mediate(mainView);
		//mediatorMap.unmediate(mainView);
	
	}
	
	////////////////////////////
	// called just before module is disposed to put your clean-up code here.
	// Main module don't need this function as it is never shutDown.
	////////////////////////////
	override protected function onShutDown():void {
		// dispose module
	}

}
}