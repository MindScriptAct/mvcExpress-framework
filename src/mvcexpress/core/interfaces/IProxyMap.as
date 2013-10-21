// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.interfaces {
import mvcexpress.mvc.Proxy;

/**
 * Interface to get proxy objects manually with your code, instead of automatic injection.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public interface IProxyMap {

	/**
	 * Get proxy by class. Alternative to injecting proxy automatically.                                                                    <p>
	 *        You might want to get proxy manually then your proxy has dynamic name.
	 *        Also you might want to get proxy manually if your proxy is needed only in rare cases or only for short time.
	 *            (for instance - you need it only in onRegister() function.)                                                                </p>
	 * @param    proxyClass    class of proxy, proxy object is mapped to.
	 * @param    name        Optional name if you need more then one proxy instance of same class.
	 */
	function getProxy(injectClass:Class, name:String = ""):Proxy;
}
}