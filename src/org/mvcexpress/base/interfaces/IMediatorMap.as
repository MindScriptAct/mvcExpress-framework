package org.mvcexpress.base.interfaces {

/**
 * Interface for MediatorMap. Mediators use it with this interface.
 * @author
 */
public interface IMediatorMap {
	function mediate(viewObject:Object):void;
	function unmediate(viewObject:Object):void;
}
}