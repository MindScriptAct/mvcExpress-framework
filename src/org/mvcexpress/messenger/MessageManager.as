package org.mvcexpress.messenger {
	import org.mvcexpress.namespace.pureLegsCore;
	
/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MessageManager {
	
	static private var _messengerCount:int;
	
	public function MessageManager() {
		
	}
	
	static public function get messengerCount():int {
		return _messengerCount;
	}
	
	static pureLegsCore function increaseMessengerCount():void {
		_messengerCount++
	}
	
}
}