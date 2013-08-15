// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.mvc {
import mvcexpress.extensions.live.core.ProcessMapLive;
import mvcexpress.mvc.PooledCommand;

/**
 * Command that is automatically pooled.
 * All PooledCommand's are automatically pooled after execution - unless lock() is used.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 *
 * @version live.1.0.beta2
 */
public class PooledCommandLive extends PooledCommand {

	/** Handles application processes. */
	public var processMap:ProcessMapLive;

}
}