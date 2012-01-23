package {
import flash.display.Sprite;
import flash.utils.getTimer;
import flash.utils.setTimeout;
import test.TestingElm;

/**
 * COMMENT
 * @author rbanevicius
 */
public class PublicVSGetTest extends Sprite {
	static private const TEST_COUNT:Number = 1000000;
	
	public function PublicVSGetTest(){
		setTimeout(start, 500);
	
	}
	
	private function start():void {
	
		var testElmnt:TestingElm = new TestingElm(null);
		
		var spr:Object;
		
		
		
		/*---------->*/var testTime_1:int = getTimer();
		/*->*/var testCount_1:int = TEST_COUNT;
		/*->*/for (var i:int = 0; i < testCount_1; i++) {
		spr = testElmnt.obj1;
		/*->*/}
		/*->*/var testResult_1:int = getTimer() - testTime_1;
		/*---------->*/trace("public", "\tTotal time:", testResult_1, "\tavr time:", testResult_1 / testCount_1,"\t[*"+testCount_1+"]", "\tRuns per 1ms:", 1 / (testResult_1 / testCount_1));
		
		
		
		/*---------->*/var testTime_getter:int = getTimer();
		/*->*/var testCount_getter:int = TEST_COUNT;
		/*->*/for (var j:int = 0; j < testCount_getter; j++) {
		spr = testElmnt.obj2;
		/*->*/}
		/*->*/var testResult_getter:int = getTimer() - testTime_getter;
		/*---------->*/trace("getter", "\tTotal time:", testResult_getter, "\tavr time:", testResult_getter / testCount_getter,"\t[*"+testCount_getter+"]", "\tRuns per 1ms:", 1 / (testResult_getter / testCount_getter));
		
		
	}

}
}