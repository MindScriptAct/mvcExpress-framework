// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.core {
import flash.utils.Dictionary;

import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.live.modules.ModuleLive;
import mvcexpress.extensions.live.mvc.MediatorLive;
import mvcexpress.mvc.Mediator;

use namespace pureLegsCore;

/**
 * Handles application mediators.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version live.1.0.beta2
 */
public class MediatorMapLive extends MediatorMap {

	// used internally to work with processes.
	private var processMap:ProcessMapLive;

	public function MediatorMapLive($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap) {
		super($moduleName, $messenger, $proxyMap);
	}

	override protected function prepareMediator(mediator:Mediator, mediatorClass:Class, viewObject:Object, injectClasses:Vector.<Class> = null):Boolean {
		use namespace pureLegsCore;

		if (mediator is MediatorLive) {
			(mediator as MediatorLive).processMap = processMap;
		}
		return super.prepareMediator(mediator, mediatorClass, viewObject, injectClasses);
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