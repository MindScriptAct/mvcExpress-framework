package com.mindScriptAct.mvcExpressSpeedTest.controller {
import org.mvcexpress.mvc.Command;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class WithProxyCommViews5Command extends Command {
	
	[Inject]
	public var blankProxy1:BlankProxy;
	
	[Inject]
	public var blankProxy2:BlankProxy;	
	
	[Inject]
	public var blankProxy3:BlankProxy;	
	
	[Inject]
	public var blankProxy4:BlankProxy;	
	
	[Inject]
	public var blankProxy5:BlankProxy;		
	
	public function execute(params:Object):void {
		//trace( "WithProxyCommViewsCommand.execute > msg : " + msg );
		blankProxy1.sendTestMessage();
	}

}
}