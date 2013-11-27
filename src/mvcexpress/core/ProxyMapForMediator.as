// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.mvc.Proxy;

/**
 * INTERNAL FRAMEWORK CLASS.
 * ProxyMap wraper for mediators.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class ProxyMapForMediator {

	private var proxyMap:ProxyMap;

	public function ProxyMapForMediator(proxyMap:ProxyMap) {
		this.proxyMap = proxyMap;
	}

	public function getProxy(proxyClass:Class, name:String = null):Proxy {
		use namespace pureLegsCore;

		return proxyMap.mediatorGetProxy(proxyClass, name);
	}
}
}
