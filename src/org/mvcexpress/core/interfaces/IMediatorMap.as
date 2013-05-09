// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.interfaces {

/**
 * Interface for Mediator. MediatorsMap use mediators with this interface.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public interface IMediatorMap {
	function mediate(viewObject:Object):void;
	function mediateWith(viewObject:Object, mediatorClass:Class, injectClass:Class = null):void;
	function unmediate(viewObject:Object):void;
	
	function isViewMapped(viewObject:Object):Boolean;
}
}