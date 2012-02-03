package com.mindScriptAct.smallSample.controller {
import flash.geom.Matrix;
import org.mvcexpress.mvc.Command;

public class TestCommand extends Command {
	
	public function execute(params:Matrix):void {
		trace("TestCommand.execute > params : " + params);
	}

}
}