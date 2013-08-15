// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.interfaces {
import mvcexpress.mvc.Proxy;

/**
 * Interface to get proxy objects manually with your code, instead of automatic injection.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 *
 * @version 2.0.beta2
 */
public interface IProxyMap {

	/**
	 * Get mapped proxy. This is needed to get proxy manually instead of inject it automatically.                    <br>
	 * You might wont to get proxy manually then your proxy has dynamic name.                                        <br>
	 * Also you might want to get proxy manually if your proxy is needed only in rare cases or only for short time.  <br>
	 * (for instance - you need it only in onRegister() function.)
	 * @param    injectClass    Optional class to use for injection, if null proxyObject class is used. It is helpful if you want to map proxy interface or subclass.
	 * @param    name        Optional name if you need more then one proxy instance of same class.
	 */
	function getProxy(injectClass:Class, name:String = ""):Proxy;
}
}