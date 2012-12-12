package com.mindScriptAct.mvcExpressLive.processes.frameProc.tasks {
import flash.geom.Point;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class ATask extends Task {
	
	[Inject (name="testObjectPoints")]
	public var pointObjects:Vector.<Point>;
	
	override public function run():void {
		trace("ATask.run");
		
		
		for (var i:int = 0; i < pointObjects.length; i++) {
			trace( "pointObjects >>>>>>>>>>>>>>>>>>> : " + pointObjects[i] );
			pointObjects[i].x = Math.random() * 500;
			pointObjects[i].y = Math.random() * 500;
		}
	}

}
}