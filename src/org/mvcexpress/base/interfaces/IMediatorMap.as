// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.base.interfaces {

/**
 * Interface for Mediator. MediatorsMap use mediators with this interface.
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public interface IMediatorMap {
	function mediate(viewObject:Object):void;
	function unmediate(viewObject:Object):void;
}
}