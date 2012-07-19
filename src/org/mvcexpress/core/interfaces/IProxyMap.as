package org.mvcexpress.core.interfaces {
import org.mvcexpress.mvc.Proxy;

/**
 * Interface to get proxy objects inside your code insted of automatic injection.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public interface IProxyMap {
	function getProxy(injectClass:Class, name:String = ""):Proxy;

}
}