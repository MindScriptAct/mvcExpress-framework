// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.dlc.live.modules {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.dlc.live.core.CommandMapLive;
import mvcexpress.dlc.live.core.MediatorMapLive;
import mvcexpress.dlc.live.core.ProcessMapLive;
import mvcexpress.dlc.live.core.ProxyMapLive;
import mvcexpress.modules.ModuleCore;

/**
 * Core Module class. Used if you don't want your module be display object.
 * Usually it is good idea to create your main(shell) module from ModuleCore.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleCoreLive extends ModuleCore {

	// process map
	protected var processMap:ProcessMapLive;

	/**
	 * CONSTRUCTOR
	 * @param    moduleName    module name that is used for referencing a module. (if not provided - unique name will be generated.)
	 * @param    autoInit    if set to false framework is not initialized for this module. If you want to use framework features you will have to manually init() it first.
	 */
	public function ModuleCoreLive(moduleName:String = null, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {
		if (!mediatorMapClass) {
			mediatorMapClass = MediatorMapLive;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		if (!proxyMapClass) {
			proxyMapClass = ProxyMapLive;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		if (!commandMapClass) {
			commandMapClass = CommandMapLive;
		} else {
			// TODO : in DEBUG chceck if subclasses right class
		}
		super(moduleName, mediatorMapClass, proxyMapClass, commandMapClass, messengerClass);

		use namespace pureLegsCore

		processMap = new ProcessMapLive(_moduleName, _messenger, proxyMap as ProxyMapLive);
		(proxyMap as ProxyMapLive).setProcessMap(processMap);
		(mediatorMap as MediatorMapLive).setProcessMap(processMap);
		(commandMap as CommandMapLive).setProcessMap(processMap);
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

}
}