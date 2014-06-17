// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.mvc.Proxy;

/**
 * INTERNAL FRAMEWORK CLASS.
 * ProxyMap wrapper for mediators.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc4
 */
public class ProxyMapForMediator {

	private var proxyMap:ProxyMap;

	// CONSTRUCTOR
	public function ProxyMapForMediator(proxyMap:ProxyMap) {
		this.proxyMap = proxyMap;
	}

	/**
	 * Get proxy. If MvcExpress.usePureMediators is set to true - only proxies that are mapped to be accessible for mediator can be received. ('mediatorInjectClass' must be set then proxy is mapped.)
	 * @param    proxyClass    class of proxy, mapped with mediatorInjectClass parameter.
	 * @param    name        Optional name if you need more then one proxy instance of same class.
	 * @return
	 */
	public function getProxy(proxyClass:Class, name:String = null):Proxy {
		use namespace pureLegsCore;

		return proxyMap.mediatorGetProxy(proxyClass, name);
	}

	/**
	 * Checks if mediator can get proxy, with given inject class and name. (It must be mapped, and mediator must have permission to get this proxy. check 'MvcExpress.usePureMediators' and MediatorMap->map() function for more details.)
	 * @param    proxyClass    class of proxy, mapped with mediatorInjectClass parameter.
	 * @param    name        Optional name if you need more then one proxy instance of same class.
	 * @return    true if mediator can get proxy object.
	 */
	public function canGetProxy(proxyClass:Class, name:String = null):Boolean {
		use namespace pureLegsCore;

		return proxyMap.mediatorCanGetProxy(proxyClass, name);

	}
}
}
