// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.combo.scopedLive.modules {
import mvcexpress.core.ExtensionManager;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.combo.scopedLive.core.CommandMapScopedLive;
import mvcexpress.extensions.combo.scopedLive.core.ProxyMapScopedLive;
import mvcexpress.extensions.live.core.MediatorMapLive;
import mvcexpress.extensions.live.core.ProcessMapLive;
import mvcexpress.extensions.scoped.modules.ModuleScoped;

/**
 * Core Module class. Used if you don't want your module be display object.
 * Usually it is good idea to create your main(shell) module from ModuleCore.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version live.1.0.beta2
 */
public class ModuleScopedLive extends ModuleScoped {

	// process map
	protected var processMap:ProcessMapLive;

	/**
	 * CONSTRUCTOR
	 * @param    moduleName    module name that is used for referencing a module. (if not provided - unique name will be generated.)
	 */
	public function ModuleScopedLive(moduleName:String = null, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {
		use namespace pureLegsCore

		CONFIG::debug {
			enableExtension(EXTENSION_LIVE_ID);
		}

		if (!mediatorMapClass) {
			mediatorMapClass = MediatorMapLive;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		if (!proxyMapClass) {
			proxyMapClass = ProxyMapScopedLive;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		if (!commandMapClass) {
			commandMapClass = CommandMapScopedLive;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		super(moduleName, mediatorMapClass, proxyMapClass, commandMapClass, messengerClass);

		processMap = new ProcessMapLive(moduleName, messenger, proxyMap);
		(proxyMap as ProxyMapScopedLive).setProcessMap(processMap);
		(mediatorMap as MediatorMapLive).setProcessMap(processMap);
		(commandMap as CommandMapScopedLive).setProcessMap(processMap);
	}

	/** @inheritDoc */
	override public function disposeModule():void {
		use namespace pureLegsCore

		super.disposeModule();
		if (processMap) {
			processMap.dispose();
			processMap = null;
		}
	}

	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
		// Lists all processes and tasks.
	public function listMappedProcesses():String {
		return processMap.listProcesses();
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore const EXTENSION_LIVE_ID:int = ExtensionManager.getExtensionIdByName(pureLegsCore::EXTENSION_LIVE_NAME);

	/** @private */
	CONFIG::debug
	static pureLegsCore const EXTENSION_LIVE_NAME:String = "live";

}
}