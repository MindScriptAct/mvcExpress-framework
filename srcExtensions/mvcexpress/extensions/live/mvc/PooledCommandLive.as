// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.mvc {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.live.core.ProcessMapLive;
import mvcexpress.extensions.live.modules.ModuleLive;
import mvcexpress.mvc.PooledCommand;

use namespace pureLegsCore;

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

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleLive.pureLegsCore::EXTENSION_LIVE_ID;

	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleLive.pureLegsCore::EXTENSION_LIVE_NAME

}
}