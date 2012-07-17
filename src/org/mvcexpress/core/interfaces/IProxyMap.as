package org.mvcexpress.core.interfaces {
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public interface IProxyMap {
	function getProxy(injectClass:Class, name:String = "", isHosted:Boolean = false):Proxy;

}
}