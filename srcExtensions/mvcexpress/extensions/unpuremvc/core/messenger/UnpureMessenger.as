package mvcexpress.extensions.unpuremvc.core.messenger {
import mvcexpress.MvcExpress;
import mvcexpress.core.messenger.HandlerVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.messenger.TraceMessenger_send;
import mvcexpress.core.traceObjects.messenger.TraceMessenger_send_handler;

/**
 * @version unpuremvc.1.0.beta2
 */
public class UnpureMessenger extends Messenger {

	private var lastMessageType:String;

	public function UnpureMessenger($moduleName:String) {
		super($moduleName);
	}

	/**
	 * Runs all handler functions associated with message type, and send params object as single parameter.
	 * @param    type                message type to find needed handlers
	 * @param    params                parameter object that will be sent to all handler functions as single parameter.
	 */
	override public function send(type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceMessenger_send(moduleName, type, params));
		}
		var messageList:Vector.<HandlerVO> = messageRegistry[type];
		var handlerVo:HandlerVO;
		var delCount:int; // = 0;
		if (messageList) {
			var mesageCount:int = messageList.length;
			for (var i:int; i < mesageCount; i++) {
				handlerVo = messageList[i];
				// check if message is not marked to be removed. (disabled)
				if (handlerVo.handler == null) {
					delCount++;
				} else {

					// if some MsgVOs marked to be removed - move all other constants to there place.
					if (delCount) {
						messageList[i - delCount] = messageList[i];
					}

					// check if handling function handles commands.
					if (handlerVo.isExecutable) {
						handlerVo.handler(type, params);
					} else {
						CONFIG::debug {
							// FOR DEBUG viewing only(mouse over over variables while in debugger mode.)
							/* Failed message type: */
							type;
							/* Failed handler class: */
							handlerVo.handlerClassName;
							//
							MvcExpress.debug(new TraceMessenger_send_handler(moduleName, type, params, handlerVo.handler, handlerVo.handlerClassName));
						}
						lastMessageType = type;
						handlerVo.handler(params);
					}
				}
			}
			// remove all removed handlers.
			if (delCount) {
				messageList.splice(mesageCount - delCount, delCount);
			}
		}

	}

	/** @private */
	pureLegsCore function getLastMessageType():String {
		var retVal:String = lastMessageType;
		lastMessageType = null;
		return retVal;
	}
}
}
