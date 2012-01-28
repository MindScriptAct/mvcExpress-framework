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
	private var view:PureLegsSample;
	
	public function SampleAppModule(view:PureLegsSample) {
		this.view = view;
		super();
		
	}
	
	override protected function onStartUp():void {
		trace( "SampleAppModule.onStartup" );
		
		////////////////////////////
		// Model
		////////////////////////////
		
		// TODO - decide : if maped singleton model uses enother not maped model.. it will end up with error...
		// TODO - decide : Alternatively... singleton models could be initialized on first use... (cost a bit performance..) but solves the isue..
		
		modelMap.mapObject(new SampleEmptyModel("Some test info"));
		modelMap.mapObject(new SampleEmptyModel("Interfaced model"), ISampleEmptyModel);
		modelMap.mapObject(new SampleEmptyModel("Named and interfaced model"), ISampleEmptyModel, "namedSampleEmptyModel");
		
		modelMap.mapClass(SampleModel);
		modelMap.mapClass(SampleModel, null, "testType");
		
		modelMap.mapClass(SampleModel, ISampleModel);
		modelMap.mapClass(SampleModel, ISampleModel, "interfaceModel");
		
		////////////////////////////
		// View
		////////////////////////////
		mediatorMap.map(PureLegsSample, SampleAppMediator);
		//mediatorMap.unmapMediator(PureLegsSample);
		
		mediatorMap.mediate(view);
		// TODO - decide : rething namings..
		//mediatorMap.unmediate(view);
		
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
	
	}

}
}