package com.mindScriptAct.pureLegsSample.controller {
import com.mindScriptAct.pureLegsSample.messages.Msg;
import com.mindScriptAct.pureLegsSample.model.SampleModel;
import org.pureLegs.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleCommand extends Command {
	
	////////////////////////////
	// geting model...
	////////////////////////////
	[Inject]
	public var sampleModel:SampleModel;
	
	// execute MUST have 1 and only one parameter. This parameter can be typed(or be Object type)
	
	public function execute(params:Object):void {
		trace("SampleCommand.execute > params : " + params);
		
		//sampleModel.sendTestMessage();
		
		////////////////////////////
		// Model
		////////////////////////////
		
		modelMap
		
		////////////////////////////
		// view
		////////////////////////////
		
		mediatorMap
		
		////////////////////////////
		// view
		////////////////////////////
		
		commandMap
		
		////////////////////////////
		// comunication
		////////////////////////////
		
		sendMessage(Msg.TEST_DATA_MESSAGE, "send some data to listeners......");
	
	}

}
}