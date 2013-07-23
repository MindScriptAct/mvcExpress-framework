// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.dlc.live.core {
import mvcexpress.core.*;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.dlc.live.mvc.ProxyLive;
import mvcexpress.mvc.Proxy;

use namespace pureLegsCore;

/**
 * ProxyMap is responsible for storing proxy objects and handling injection.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
use namespace pureLegsCore;
public class ProxyMapLive extends ProxyMap {

	// pushed into proxies so they could provide data objects
	private var processMap:ProcessMapLive;

	public function ProxyMapLive($moduleName:String, $messenger:Messenger) {
		super($moduleName, $messenger);
	}

	//----------------------------------
	//     internal stuff
	//----------------------------------

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

		if (proxyObject is ProxyLive) {
			(proxyObject as ProxyLive).setProcessMap(processMap);
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


}
}
