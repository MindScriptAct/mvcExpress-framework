// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.combo.scopedLive.mvc {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.live.core.ProcessMapLive;
import mvcexpress.extensions.live.modules.ModuleLive;
import mvcexpress.extensions.scoped.mvc.CommandScoped;

use namespace pureLegsCore;

/**
 * Command, handles business logic of your application.                                                                                                    </br>
 * You most likely need it then:                                                                                                                            </br>
 *    - if you need to change application state with one or more logical statement.                                                                            </br>
 *    - if you need more then one unrelated proxies injected to make a decision.                                                                            </br>
 * Commands can get proxies injected and can send constants                                                                                                    </br>
 * <b><p>
 * It MUST contain custom execute(params:Object) function. Parameter can be typed as you wish.                                                                </br>
 * It is best practice to use same type as you use in message, that triggers this command.                                                                    </br>
 * If message does not send any parameter object - you still must have singe parameter, for example: execute(blank:Object). This parameter will be null.    </br>
 * </p></b>
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version live.1.0.beta2
 */
dynamic public class CommandScopedLive extends CommandScoped {

	/** Handles application processes. */
	public var processMap:ProcessMapLive;

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleLive.EXTENSION_LIVE_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleLive.EXTENSION_LIVE_NAME

}
}