package org.mvcexpress.mvc {
import flash.utils.Dictionary;
import org.mvcexpress.core.namespace.pureLegsCore;

/**
 * Command that is autamaticaly pooled.
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class PooledCommand extends Command {
		
	private var _isLocked:Boolean = false;
	
	/**
	 * Is command locked for pooling or not.
	 */
	override public function get isLocked():Boolean {
		return _isLocked;
	}
	
	public function lock():void {
		_isLocked = true;
	}
	
	public function unlock():void {
		if (_isLocked) {
			_isLocked = false;
			use namespace pureLegsCore;
			if (isExecuting) {
				commandMap.poolCommand(this);
			}
		} else {
			throw Error("You are trying to unlock PooledCommand that is not locked yet.");
		}
	}

}
}