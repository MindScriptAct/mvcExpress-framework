// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.combo.scopedLive.mvc {
import mvcexpress.extensions.live.core.ProcessMapLive;
import mvcexpress.extensions.live.modules.ModuleLive;
import mvcexpress.extensions.scoped.mvc.PooledCommandScoped;
import mvcexpress.mvc.PooledCommand;

/**
 * Command that is automatically pooled.
 * All PooledCommand's are automatically pooled after execution - unless lock() is used.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 *
 * @version live.1.0.beta2
 */
public class PooledCommandScopedLive extends PooledCommandScoped {

	/** Handles application processes. */
	public var processMap:ProcessMapLive;

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static public var extension_id:int = ModuleLive.EXTENSION_LIVE_ID;

	CONFIG::debug
	static public var extension_name:String = ModuleLive.EXTENSION_LIVE_NAME

}
}