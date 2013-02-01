// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import org.mvcexpress.core.namespace.pureLegsCore;

/**
 * Command that is automatically pooled.
 * All PooledCommand's are automatically pooled after execution - unless lock() is used.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class PooledCommand extends Command {
	
	/**
	 * Stores information if command is locked from automatic pooling by user.
	 * @private */
	private var _isLocked:Boolean;// = false;
	
	/**
	 * Shows if command is locked, and will not be automatically pooling after execution, or not.
	 * Asynchronous PooledCommand must be locked then used, and unlocked then they are done with there work.
	 */
	public function get isLocked():Boolean {
		return _isLocked;
	}
	
	/**
	 * Locks PooledCommand to avoid automatic pooling after execution.
	 * Command lock(), unlock() functions are used with asynchronous commands.
	 */
	public function lock():void {
		_isLocked = true;
	}
	
	/**
	 * Unlock and pool PooledCommand.
	 * Only previously locked commands can be unlocked, or error will be thrown.
	 * Command lock(), unlock() functions are used with asynchronous commands.
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