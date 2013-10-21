// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.mvc {
import mvcexpress.core.namespace.pureLegsCore;

/**
 * Command that is automatically pooled.                                                                                                                   <p>
 * Pooled commands improves performance as they need to be constructed only once. Use them with commands that are executed very often.                     <br/>
 * You can lock() command to prevent it from being pooled after execute, locked commands are pooled after you unlock() them.                                 </p>
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class PooledCommand extends Command {

	/** Stores information if command is locked from automatic pooling by user.
	 * @private */
	private var _isLocked:Boolean;// = false;

	/** Shows if command is locked, and will not be automatically pooling after execution, or not.
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