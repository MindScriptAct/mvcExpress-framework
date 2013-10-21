// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.interfaces {

/**
 * Interface for Mediator. MediatorsMap use mediators with this interface.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public interface IMediatorMap {

	/**
	 * Mediates provided viewObject with all mapped mediator.
	 * Automatically instantiates mediator class(es), handles all injections(including view object injection), and calls onRegister function.            <p>
	 * Throws error if no mediator classes are mapped to viewObject class.                                                                                </p>
	 * @param    viewObject    view object to mediate.
	 */
	function mediate(viewObject:Object):void;

	/**
	 * Mediates viewObject with specified mediator class.                                                                                                    <p>
	 * This function will mediate your view without mapping view class to mediator class.
	 * It is usually better practice to use 2 step mediation(map() then mediate()) instead of this function. But sometimes it is not possible/useful.        </p>
	 * @param    viewObject        view object to mediate.
	 * @param    mediatorClass    mediator class that will be instantiated and used to mediate view object
	 * @param    injectClass        inject mediator as this class.
	 */
	function mediateWith(viewObject:Object, mediatorClass:Class, injectClass:Class = null):void;

	/**
	 * Stops view object mediation by all or specific mediator.                                                                                                        <p>
	 * If any mediator is mediating this viewObject - onRemove mediator function is called, all message handlers and all event listeners(adedd with addListener) are removed automatically, and mediator is disposed. </p>
	 * @param    viewObject    view object witch mediator will be destroyed.
	 * @param    mediatorClass    optional parameter to unmediate specific mediator class. If this not set - all mediators will be removed.
	 */
	function unmediate(viewObject:Object, mediatorClass:Class = null):void;

	/**
	 * Checks if any or specific mediator class is mapped to view class.
	 * @param    viewClass        view class that has to be mediated by mediator class then mediate(viewObject) is called.
	 * @param    mediatorClass    Optional Mediator class, if provided will check if viewClass is mapped to this specific mediator class.
	 * @return                    true if view class is already mapped to mediator class.
	 */
	function isMapped(viewClass:Class, mediatorClass:Class = null):Boolean;

	/**
	 * Checks if view object is mediated by any or specific mediator.
	 * @param viewObject        View object to check if it is mediated.
	 * @param mediatorClass        optional parameter to check if view is mediated by specific mediator.
	 * @return
	 */
	function isMediated(viewObject:Object, mediatorClass:Class = null):Boolean;
}
}