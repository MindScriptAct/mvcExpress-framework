package org.mvcexpress.mvc {
import flash.utils.Dictionary;
import org.mvcexpress.core.namespace.pureLegsCore;

/**
 * Command that is autamaticaly pooled.
 * All pooled commands are pooled unless locked after execution. 
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class PooledCommand extends Command {
	
	private var _isLocked:Boolean = false;
	
	/**
	 * Is command locked for pooling or not.
	 */
	public function get isLocked():Boolean {
		return _isLocked;
	}
	
	/**
	 * Locks pooled command, to avoid automatic pooling after execution.
	 * Command lock() -> unlock() functions are used with asynchronous commands.
	 */
	public function lock():void {
		_isLocked = true;
	}
	
	/**
	 * Unlock and pool PooledCommand.
	 * Only previously locked commands can be unlocked.
	 * Command lock() -> unlock() functions are used with asynchronous commands.
	 */
	public function unlock():void {
		if (_isLocked) {
			_isLocked = false;
			use namespace pureLegsCore;
			if (isExecuting) {
				commandMap.poolCommand(this);
			}
		} else {
			throw Error("You are trying to unlock PooledCommand that was never locked. lock() it first.");
		}
	}

}
}