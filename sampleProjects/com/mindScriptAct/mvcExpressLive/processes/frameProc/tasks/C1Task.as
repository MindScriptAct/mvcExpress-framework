package com.mindScriptAct.mvcExpressLive.processes.frameProc.tasks {
import com.mindScriptAct.mvcExpressLive.view.LiveViewTest;
import flash.geom.Point;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class C1Task extends Task {
	
	[Inject(name="testObjectPoints")]
	public var pointObjects:Vector.<Point>;
	
	[Inject(name="liveViewObjects")]
	public var pointViewObjects:Vector.<LiveViewTest>;
	
	override public function run():void {
		trace("C1Task.run");
		
		for (var i:int = 0; i < pointViewObjects.length; i++) {
			pointViewObjects[i].x = pointObjects[i].x;
			pointViewObjects[i].y = pointObjects[i].y;
		}
	}

}
}