package com.mindScriptAct.mediatorEventSpeedTest.view {
import com.mindScriptAct.mediatorEventSpeedTest.MediatorEventSpeedModule;

import flash.events.MouseEvent;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MediatorEventSpeedModuleMediator extends Mediator {

	[Inject]
	public var view:MediatorEventSpeedModule;

	//[Inject]
	//public var myProxy:MyProxy;

	private var testNr:int;
	private var diferentEventCount:int = 100000;

	override protected function onRegister():void {
		trace("MediatorEventSpeedModuleMediator.onRegister");

		testNr = 0;
		setTimeout(doTest, 2000);


		/*
		 view.graphics.lineStyle(0.1, 0xFF0000);
		 view.graphics.beginFill(0x0000FF);
		 view.graphics.drawRect(10, 10, 300, 200);
		 view.graphics.endFill();


		 trace(view.stage.hasEventListener(MouseEvent.CLICK));
		 view.stage.addEventListener(MouseEvent.CLICK, blankHandler);
		 trace(view.stage.hasEventListener(MouseEvent.CLICK));
		 view.stage.removeEventListener(MouseEvent.CLICK, blankHandler);
		 trace(view.stage.hasEventListener(MouseEvent.CLICK));


		 view.stage.addEventListener(MouseEvent.CLICK, blankHandler);
		 view.stage.addEventListener(MouseEvent.CLICK, blankHandler);
		 view.stage.addEventListener(MouseEvent.CLICK, blankHandler);
		 view.stage.addEventListener(MouseEvent.CLICK, blankHandler);
		 trace(view.stage.hasEventListener(MouseEvent.CLICK));
		 view.stage.removeEventListener(MouseEvent.CLICK, blankHandler);
		 trace(view.stage.hasEventListener(MouseEvent.CLICK));

		 view.stage.addEventListener(MouseEvent.CLICK, blankHandler);
		 view.stage.addEventListener(MouseEvent.CLICK, blankHandler2);
		 trace(view.stage.hasEventListener(MouseEvent.CLICK));
		 view.stage.removeEventListener(MouseEvent.CLICK, blankHandler);
		 trace(view.stage.hasEventListener(MouseEvent.CLICK));
		 view.stage.removeEventListener(MouseEvent.CLICK, blankHandler);
		 trace(view.stage.hasEventListener(MouseEvent.CLICK));
		 view.stage.removeEventListener(MouseEvent.CLICK, blankHandler2);
		 trace(view.stage.hasEventListener(MouseEvent.CLICK));

		 //*/

	}

	private function doTest():void {

		switch (testNr) {
			case 0:
				/*---------->*/
				var testTime_standartAdd:int = getTimer();
				/*->*/
				var testCount_standartAdd:int = 100000;
				/*->*/
				for (var i1:int = 0; i1 < testCount_standartAdd; i1++) {
					view.stage.addEventListener(MouseEvent.CLICK, blankHandler);
					/*->*/
				}
				/*->*/
				var testResult_standartAdd:int = getTimer() - testTime_standartAdd;
				/*---------->*/
				trace("standartAdd:   ", "\tTotal time:", testResult_standartAdd, "\tavr time:", testResult_standartAdd / testCount_standartAdd, "\t[*" + testCount_standartAdd + "]", "\tRuns per 1ms:", 1 / (testResult_standartAdd / testCount_standartAdd));
				break;
			case 1:
				/*---------->*/
				var testTime_standartRemove:int = getTimer();
				/*->*/
				var testCount_standartRemove:int = 100000;
				/*->*/
				for (var k1:int = 0; k1 < testCount_standartRemove; k1++) {
					view.stage.removeEventListener(MouseEvent.CLICK, blankHandler);
					/*->*/
				}
				/*->*/
				var testResult_standartRemove:int = getTimer() - testTime_standartRemove;
				/*---------->*/
				trace("standartRemove:", "\tTotal time:", testResult_standartRemove, "\tavr time:", testResult_standartRemove / testCount_standartRemove, "\t[*" + testCount_standartRemove + "]", "\tRuns per 1ms:", 1 / (testResult_standartRemove / testCount_standartRemove));
				break;
			case 2:
				/*---------->*/
				var testTime_mediatorAdd:int = getTimer();
				/*->*/
				var testCount_mediatorAdd:int = 100000;
				/*->*/
				for (var j1:int = 0; j1 < testCount_mediatorAdd; j1++) {
					addListener(view.stage, MouseEvent.CLICK, blankHandler);
					/*->*/
				}
				/*->*/
				var testResult_mediatorAdd:int = getTimer() - testTime_mediatorAdd;
				/*---------->*/
				trace("mediatorAdd:   ", "\tTotal time:", testResult_mediatorAdd, "\tavr time:", testResult_mediatorAdd / testCount_mediatorAdd, "\t[*" + testCount_mediatorAdd + "]", "\tRuns per 1ms:", 1 / (testResult_mediatorAdd / testCount_mediatorAdd));
				break;
			case 3:
				/*---------->*/
				var testTime_mediatorRemove:int = getTimer();
				/*->*/
				var testCount_mediatorRemove:int = 100000;
				/*->*/
				for (var l1:int = 0; l1 < testCount_mediatorRemove; l1++) {
					removeListener(view.stage, MouseEvent.CLICK, blankHandler);
					/*->*/
				}
				/*->*/
				var testResult_mediatorRemove:int = getTimer() - testTime_mediatorRemove;
				/*---------->*/
				trace("mediatorRemove:", "\tTotal time:", testResult_mediatorRemove, "\tavr time:", testResult_mediatorRemove / testCount_mediatorRemove, "\t[*" + testCount_mediatorRemove + "]", "\tRuns per 1ms:", 1 / (testResult_mediatorRemove / testCount_mediatorRemove));
				break;


			case 4:
				/*---------->*/
				var testTime_standartUniqueAdd:int = getTimer();
				/*->*/
				var testCount_standartUniqueAdd:int = 100000;
				/*->*/
				for (var i2:int = 0; i2 < testCount_standartUniqueAdd; i2++) {
					view.stage.addEventListener("event_" + (i2 % diferentEventCount), blankHandler);
					/*->*/
				}
				/*->*/
				var testResult_standartUniqueAdd:int = getTimer() - testTime_standartUniqueAdd;
				/*---------->*/
				trace("standartUniqueAdd:   ", "\tTotal time:", testResult_standartUniqueAdd, "\tavr time:", testResult_standartUniqueAdd / testCount_standartUniqueAdd, "\t[*" + testCount_standartUniqueAdd + "]", "\tRuns per 1ms:", 1 / (testResult_standartUniqueAdd / testCount_standartUniqueAdd));
				break;
			case 5:
				/*---------->*/
				var testTime_standartUniqueRemove:int = getTimer();
				/*->*/
				var testCount_standartUniqueRemove:int = 100000;
				/*->*/
				for (var k2:int = 0; k2 < testCount_standartUniqueRemove; k2++) {
					view.stage.removeEventListener("event_" + (k2 % diferentEventCount), blankHandler);
					/*->*/
				}
				/*->*/
				var testResult_standartUniqueRemove:int = getTimer() - testTime_standartUniqueRemove;
				/*---------->*/
				trace("standartUniqueRemove:", "\tTotal time:", testResult_standartUniqueRemove, "\tavr time:", testResult_standartUniqueRemove / testCount_standartUniqueRemove, "\t[*" + testCount_standartUniqueRemove + "]", "\tRuns per 1ms:", 1 / (testResult_standartUniqueRemove / testCount_standartUniqueRemove));
				break;
			case 6:
				/*---------->*/
				var testTime_mediatorUniqueAdd:int = getTimer();
				/*->*/
				var testCount_mediatorUniqueAdd:int = 100000;
				/*->*/
				for (var j2:int = 0; j2 < testCount_mediatorUniqueAdd; j2++) {
					addListener(view.stage, "event_" + (j2 % diferentEventCount), blankHandler);
					/*->*/
				}
				/*->*/
				var testResult_mediatorUniqueAdd:int = getTimer() - testTime_mediatorUniqueAdd;
				/*---------->*/
				trace("mediatorUniqueAdd:   ", "\tTotal time:", testResult_mediatorUniqueAdd, "\tavr time:", testResult_mediatorUniqueAdd / testCount_mediatorUniqueAdd, "\t[*" + testCount_mediatorUniqueAdd + "]", "\tRuns per 1ms:", 1 / (testResult_mediatorUniqueAdd / testCount_mediatorUniqueAdd));
				break;
			case 7:
				/*---------->*/
				var testTime_mediatorUniqueRemove:int = getTimer();
				/*->*/
				var testCount_mediatorUniqueRemove:int = 100000;
				/*->*/
				for (var l2:int = 0; l2 < testCount_mediatorUniqueRemove; l2++) {
					removeListener(view.stage, "event_" + (l2 % diferentEventCount), blankHandler);
					/*->*/
				}
				/*->*/
				var testResult_mediatorUniqueRemove:int = getTimer() - testTime_mediatorUniqueRemove;
				/*---------->*/
				trace("mediatorUniqueRemove:", "\tTotal time:", testResult_mediatorUniqueRemove, "\tavr time:", testResult_mediatorUniqueRemove / testCount_mediatorUniqueRemove, "\t[*" + testCount_mediatorUniqueRemove + "]", "\tRuns per 1ms:", 1 / (testResult_mediatorUniqueRemove / testCount_mediatorUniqueRemove));
				break;


			case 8:
				/*->*/
				var testCount_mediatorAddAgain:int = 100000;
				/*->*/
				for (var m:int = 0; m < testCount_mediatorAddAgain; m++) {
					addListener(view.stage, "event_" + (m % diferentEventCount), blankHandler);
					/*->*/
				}
				break;
			case 9:
				/*---------->*/
				var testTime_mediatorRemoveAll:int = getTimer();
				removeListener(view.stage, MouseEvent.CLICK, blankHandler);
				removeAllListeners();
				/*->*/
				var testResult_mediatorRemoveAll:int = getTimer() - testTime_mediatorRemoveAll;
				/*---------->*/
				trace("mediatorRemoveALL:", "\tTotal time:", testResult_mediatorRemoveAll, "\tavr time:", testResult_mediatorRemoveAll / testCount_mediatorRemove, "\t[*" + testCount_mediatorRemove + "]", "\tRuns per 1ms:", 1 / (testResult_mediatorRemoveAll / testCount_mediatorRemove));
				break;


			default:
				break;
		}
		testNr++;
		setTimeout(doTest, 1000);


	}

	private function blankHandler(event:MouseEvent):void {
		trace("MediatorEventSpeedModuleMediator.blankHndle > event : " + event);
	}

	private function blankHandler2(event:MouseEvent):void {
		trace("MediatorEventSpeedModuleMediator.blankHndle2 > event : " + event);
	}

	override protected function onRemove():void {

	}

}
}
/*

 // ver 1

 standartAdd:    	Total time: 115 	avr time: 0.00115 	[*100000] 	Runs per 1ms: 869.5652173913044
 standartRemove: 	Total time: 55 	avr time: 0.00055 	[*100000] 	Runs per 1ms: 1818.181818181818
 mediatorAdd:    	Total time: 278 	avr time: 0.00278 	[*100000] 	Runs per 1ms: 359.71223021582733
 mediatorRemove: 	Total time: 3552 	avr time: 0.03552 	[*100000] 	Runs per 1ms: 28.153153153153152
 mediatorRemoveALL: 	Total time: 52 	avr time: Infinity 	[*0] 	Runs per 1ms: 0


 standartAdd:    	Total time: 122 	avr time: 0.00122 	[*100000] 	Runs per 1ms: 819.672131147541
 standartRemove: 	Total time: 71 	avr time: 0.00071 	[*100000] 	Runs per 1ms: 1408.4507042253522
 mediatorAdd:    	Total time: 309 	avr time: 0.00309 	[*100000] 	Runs per 1ms: 323.62459546925567
 mediatorRemove: 	Total time: 3580 	avr time: 0.0358 	[*100000] 	Runs per 1ms: 27.932960893854748
 mediatorRemoveALL: 	Total time: 43 	avr time: Infinity 	[*0] 	Runs per 1ms: 0

 standartAdd:    	Total time: 96 	avr time: 0.00096 	[*100000] 	Runs per 1ms: 1041.6666666666667
 standartRemove: 	Total time: 81 	avr time: 0.00081 	[*100000] 	Runs per 1ms: 1234.567901234568
 mediatorAdd:    	Total time: 320 	avr time: 0.0032 	[*100000] 	Runs per 1ms: 312.5
 mediatorRemove: 	Total time: 3439 	avr time: 0.03439 	[*100000] 	Runs per 1ms: 29.07822041291073
 mediatorRemoveALL: 	Total time: 51 	avr time: Infinity 	[*0] 	Runs per 1ms: 0



 /// ver 2

 standartAdd:    	Total time: 132 	avr time: 0.00132 	[*100000] 	Runs per 1ms: 757.5757575757576
 standartRemove: 	Total time: 62 	avr time: 0.00062 	[*100000] 	Runs per 1ms: 1612.9032258064517
 mediatorAdd:    	Total time: 116 	avr time: 0.00116 	[*100000] 	Runs per 1ms: 862.0689655172414
 mediatorRemove: 	Total time: 135 	avr time: 0.00135 	[*100000] 	Runs per 1ms: 740.7407407407406
 mediatorRemoveALL: 	Total time: 0 	avr time: NaN 	[*0] 	Runs per 1ms: NaN

 standartAdd:    	Total time: 110 	avr time: 0.0011 	[*100000] 	Runs per 1ms: 909.090909090909
 standartRemove: 	Total time: 82 	avr time: 0.00082 	[*100000] 	Runs per 1ms: 1219.5121951219512
 mediatorAdd:    	Total time: 111 	avr time: 0.00111 	[*100000] 	Runs per 1ms: 900.9009009009009
 mediatorRemove: 	Total time: 148 	avr time: 0.00148 	[*100000] 	Runs per 1ms: 675.6756756756757
 mediatorRemoveALL: 	Total time: 0 	avr time: NaN 	[*0] 	Runs per 1ms: NaN

 standartAdd:    	Total time: 116 	avr time: 0.00116 	[*100000] 	Runs per 1ms: 862.0689655172414
 standartRemove: 	Total time: 79 	avr time: 0.00079 	[*100000] 	Runs per 1ms: 1265.8227848101264
 mediatorAdd:    	Total time: 150 	avr time: 0.0015 	[*100000] 	Runs per 1ms: 666.6666666666666
 mediatorRemove: 	Total time: 149 	avr time: 0.00149 	[*100000] 	Runs per 1ms: 671.1409395973154
 mediatorRemoveALL: 	Total time: 0 	avr time: NaN 	[*0] 	Runs per 1ms: NaN

 /// ver 3

 standartAdd:    	Total time: 115 	avr time: 0.00115 	[*100000] 	Runs per 1ms: 869.5652173913044
 standartRemove: 	Total time: 59 	avr time: 0.00059 	[*100000] 	Runs per 1ms: 1694.915254237288
 mediatorAdd:    	Total time: 119 	avr time: 0.00119 	[*100000] 	Runs per 1ms: 840.3361344537815
 mediatorRemove: 	Total time: 132 	avr time: 0.00132 	[*100000] 	Runs per 1ms: 757.5757575757576
 standartUniqueAdd:    	Total time: 618 	avr time: 0.00618 	[*100000] 	Runs per 1ms: 161.81229773462783
 standartUniqueRemove: 	Total time: 3213 	avr time: 0.03213 	[*100000] 	Runs per 1ms: 31.123560535325243
 mediatorUniqueAdd:    	Total time: 550 	avr time: 0.0055 	[*100000] 	Runs per 1ms: 181.81818181818184
 mediatorUniqueRemove: 	Total time: 3675 	avr time: 0.03675 	[*100000] 	Runs per 1ms: 27.2108843537415
 mediatorRemoveALL: 	Total time: 1 	avr time: Infinity 	[*0] 	Runs per 1ms: 0





 */