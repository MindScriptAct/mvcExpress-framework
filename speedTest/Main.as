package {
import flash.display.Sprite;
import flash.utils.getTimer;
import flash.utils.setTimeout;
import org.flexunit.runner.manipulation.sortingInheritance.ClassInheritanceOrderCache;
import org.pureLegs.messenger.Message;
import org.pureLegs.messenger.Messenger;
import test.TestingElm;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Main extends Sprite {
	private var messasnger:Messenger;
	
	public function Main(){
		setTimeout(start, 500);
	}
	
	public function start():void {
		
		var functVector:Vector.<TestingElm> = new Vector.<TestingElm>();
		
		
		
		//
		messasnger = new Messenger();
		
		for (var i:int = 0; i < 10000; i++){
			messasnger.addHandler("test", handleCallBack);
			functVector.push(new TestingElm(handleCallBack));
		}
		
		var testNotice:Message = new Message("test", null);
		
		
		
		/*---------->*/var testTime_3:int = getTimer();
		/*->*/var testCount_3:int = 100;
		/*->*/for (var m:int = 0; m < testCount_3; m++) {
		for (var k:int = 0; k < 10000; k++) {
			handleCallBack(testNotice);
		}
		/*->*/}
		/*->*/var testResult_3:int = getTimer() - testTime_3;
		/*---------->*/trace("function run only.", "\tTotal time:", testResult_3, "\tavr time:", testResult_3 / testCount_3,"\t[*"+testCount_3+"]", "\tRuns per 1ms:", 1 / (testResult_3 / testCount_3));		
		
		
		/*---------->*/var testTime_2:int = getTimer();
		/*->*/var testCount_2:int = 100;
		/*->*/for (var l:int = 0; l < testCount_2; l++) {
		for (k = 0; k < 10000; k++) {
			functVector[k].handleCallBack(testNotice);
		}
		/*->*/}
		/*->*/var testResult_2:int = getTimer() - testTime_2;
		/*---------->*/trace("Object vector run", "\tTotal time:", testResult_2, "\tavr time:", testResult_2 / testCount_2,"\t[*"+testCount_2+"]", "\tRuns per 1ms:", 1 / (testResult_2 / testCount_2));
		
		
		
		/*---------->*/var testTime_1:int = getTimer();
		/*->*/var testCount_1:int = 100;
		/*->*/for (var j:int = 0; j < testCount_1; j++) {
		messasnger.send("test");
		/*->*/}
		/*->*/var testResult_1:int = getTimer() - testTime_1;
		/*---------->*/trace("send message", "\tTotal time:", testResult_1, "\tavr time:", testResult_1 / testCount_1,"\t[*"+testCount_1+"]", "\tRuns per 1ms:", 1 / (testResult_1 / testCount_1));
	
	}
	
	private function handleCallBack(msg:Message):void {
		//trace( "Main.handleCallBack > notice : " + notice );
	
	}

}
}