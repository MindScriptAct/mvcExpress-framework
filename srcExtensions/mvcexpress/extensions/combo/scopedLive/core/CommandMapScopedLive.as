// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.combo.scopedLive.core {
import flash.utils.Dictionary;

import mvcexpress.core.*;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.live.core.*;
import mvcexpress.extensions.live.modules.ModuleLive;
import mvcexpress.extensions.live.mvc.CommandLive;
import mvcexpress.extensions.scoped.core.CommandMapScoped;
import mvcexpress.mvc.Command;

use namespace pureLegsCore;

/**
 * Handles command mappings, and executes them on constants
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version live.1.0.beta2
 */
public class CommandMapScopedLive extends CommandMapScoped {

	// used internally to work with processes.
	private var processMap:ProcessMapLive;

	public function CommandMapScopedLive($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap, $mediatorMap:MediatorMap) {
		super($moduleName, $messenger, $proxyMap, $mediatorMap);
	}

	//----------------------------------
	//     Command execute
	//----------------------------------


	override protected function prepareCommand(command:Command, commandClass:Class):void {
		if (command is CommandLive) {
			(command as CommandLive).processMap = processMap;
		}
		super.prepareCommand(command, commandClass);
	}

	/**
	 * Dispose commandMap on disposeModule()
	 * @private
	 */
	override pureLegsCore function dispose():void {
		use namespace pureLegsCore;

		processMap = null;
		super.dispose();
	}

	/** @private */
	pureLegsCore function setProcessMap(value:ProcessMapLive):void {
		processMap = value;
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	override pureLegsCore function setSupportedExtensions(supportedExtensions:Dictionary):void {
		super.setSupportedExtensions(supportedExtensions);
		if (!SUPPORTED_EXTENSIONS[ModuleLive.EXTENSION_LIVE_ID]) {
			throw Error("This extension is not supported by current module. You need " + ModuleLive.EXTENSION_LIVE_NAME + " extension enabled.");
		}
	}


}
}