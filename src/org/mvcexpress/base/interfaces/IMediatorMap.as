package org.mvcexpress.base.interfaces {

/**
 * COMMENT
 * @author
 */
public interface IMediatorMap {
	function mediate(viewObject:Object):void;
	function unmediate(viewObject:Object):void;
}
}