package com.mindScriptAct.mvcExpressLive.processes.timerProc.tasks {
import com.mindScriptAct.mvcExpressLive.view.LiveViewTest;
import flash.geom.Point;

import mvcexpress.dlc.live.Task;


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

		for (var i:int = 0; i < pointObjects.length; i++) {
			pointViewObjects[i].x = pointObjects[i].x;
			pointViewObjects[i].y = pointObjects[i].y;
		}
	}

	[Test]

	public function test_element_count_eatchRun():void {
		trace("C1Task.test_element_count_eatchRun");
		assert.equals(pointObjects.length, pointViewObjects.length, "data and view object count must be the same.");
	}

	[Test(count="2")]

	public function test_randome_element_2Times():void {
		trace("C1Task.test_randome_element_2Times");
		var id:int = Math.floor(Math.random() * pointObjects.length);

		assert.equals(pointObjects[id].x, pointViewObjects[id].x, "data and view x must be the same.");
		assert.equals(pointObjects[id].y, pointViewObjects[id].y, "data and view y mist be the same.");
	}

	[Test(delay="1000")]

	public function test_all_element_position_everySecond():void {
		trace("C1Task.test_all_element_position_everySecond");
		for (var i:int = 0; i < pointObjects.length; i++) {
			assert.equals(pointObjects[i].x, pointViewObjects[i].x, "data and view x must be the same.");
			assert.equals(pointObjects[i].y, pointViewObjects[i].y, "data and view y mist be the same.");
		}
	}

	[Test(count="2",delay="2000")]

	public function test_all_element_position_twice_every2Second():void {
		trace("C1Task.test_all_element_position_twice_every2Second");
		for (var i:int = 0; i < pointObjects.length; i++) {
			assert.equals(pointObjects[i].x, pointViewObjects[i].x, "data and view x must be the same.");
			assert.equals(pointObjects[i].y, pointViewObjects[i].y, "data and view y mist be the same.");
		}
	}
}
}