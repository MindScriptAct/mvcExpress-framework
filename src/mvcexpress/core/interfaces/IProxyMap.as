// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.interfaces {
import mvcexpress.mvc.Proxy;

/**
 * Interface to get proxy objects manualy with your code, instead of automatic injection.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public interface IProxyMap {
	function getProxy(injectClass:Class, name:String = ""):Proxy;
}
}