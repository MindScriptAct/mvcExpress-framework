// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.signalsExpress.mvc {
import flash.utils.Dictionary;

import mindscriptact.signalsExpress.SignalExpress;

import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.mvc.Mediator;

use namespace pureLegsCore;

public class MediatorSignals extends Mediator {

	pureLegsCore var signalHandlerRegistry:Dictionary = new Dictionary();
	pureLegsCore var bridgeSignalRegistry:Dictionary = new Dictionary();


	public function MediatorSignals() {
		super();
	}

	protected function addSignalHandler(signal:SignalExpress, handler:Function):void {
		use namespace pureLegsCore;

		if (signalHandlerRegistry[signal] == null) {
			signalHandlerRegistry[signal] = 0;
		}
		signalHandlerRegistry[signal]++;
		signal.add(handler);
	}

	protected function removeSignalHandler(signal:SignalExpress, handler:Function):void {
		use namespace pureLegsCore;

		if (signalHandlerRegistry[signal] != null) {
			signalHandlerRegistry[signal]--;
			if (signalHandlerRegistry[signal] <= 0) {
				delete signalHandlerRegistry[signal];
			}
		}
		signal.remove(handler);
	}

	protected function removeAllSignalHandlers():void {
		use namespace pureLegsCore;

		for (var signal:Object in signalHandlerRegistry) {
			signal.removeAll();
			delete signalHandlerRegistry[signal];
		}
	}

	protected function bridgeSignalToMessage(signal:SignalExpress, messageType:String):void {
		use namespace pureLegsCore;

		if (signal.paramCount > 1) {
			throw Error("Only signals that dispatches one or zero parameters are supported. (mvcExpress messages can pass single objects only.)");
		}

		var sendMessageFunction:Function = this.sendMessage;
		var handleFunction:Function = function (param:Object = null):void {
			sendMessageFunction(messageType, param);
		};

		if (!(signal in bridgeSignalRegistry)) {
			bridgeSignalRegistry[signal] = new Dictionary();
		}
		if (!(messageType in bridgeSignalRegistry[signal])) {

			bridgeSignalRegistry[signal][messageType] = handleFunction;

			addSignalHandler(signal, handleFunction);
		}
	}

	protected function unbridgeSignalToMessage(signal:SignalExpress, messageType:String):void {
		use namespace pureLegsCore;

		if (signal in bridgeSignalRegistry) {
			if (messageType in bridgeSignalRegistry[signal]) {
				removeSignalHandler(signal, bridgeSignalRegistry[signal][messageType]);
				delete bridgeSignalRegistry[signal][messageType];
			}
		}

	}


	override pureLegsCore function remove():void {
		removeAllSignalHandlers();
		super.pureLegsCore::remove();
	}
}
}
