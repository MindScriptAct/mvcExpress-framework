// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.combo.scopedLive.core {
import flash.utils.Dictionary;

import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.combo.scopedLive.mvc.ProxyScopedLive;
import mvcexpress.extensions.live.core.*;
import mvcexpress.extensions.live.modules.ModuleLive;
import mvcexpress.extensions.live.mvc.ProxyLive;
import mvcexpress.extensions.scoped.core.ProxyMapScoped;
import mvcexpress.mvc.Proxy;

use namespace pureLegsCore;

use namespace pureLegsCore;

/**
 * ProxyMap is responsible for storing proxy objects and handling injection.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version live.1.0.beta2
 */
public class ProxyMapScopedLive extends ProxyMapScoped {

	// pushed into proxies so they could provide data objects
	private var processMap:ProcessMapLive;

	public function ProxyMapScopedLive($moduleName:String, $messenger:Messenger) {
		super($moduleName, $messenger);
	}

	//----------------------------------
	//     internal stuff
	//----------------------------------

	/** @private */
	pureLegsCore function setProcessMap(value:ProcessMapLive):void {
		processMap = value;
	}


	/**
	 * Initiates proxy object.
	 * @param    proxyObject
	 * @private
	 */
	override pureLegsCore function initProxy(proxyObject:Proxy, proxyClass:Class, injectId:String):void {
		use namespace pureLegsCore;

		if (proxyObject is ProxyScopedLive || proxyObject is ProxyLive) {
			proxyObject["setProcessMap"](processMap);
		}
		super.initProxy(proxyObject, proxyClass, injectId);
	}

	/**
	 * Dispose of proxyMap. Remove all registered proxies and set all internals to null.
	 * @private
	 */
	override pureLegsCore function dispose():void {
		use namespace pureLegsCore;

		processMap = null;
		super.dispose();
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
