// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMediatorMap_unmediate extends TraceObj {
	public var viewObject:Object;
	public var mediatorObject:Mediator;
	public var viewClass:Class;
	public var mediatorClass:Class;
	public var mediatorClassName:String;
	
	public function TraceMediatorMap_unmediate(action:String, moduleName:String, viewObject:Object) {
		super(action, moduleName);
		this.viewObject = viewObject;
	}
	
	override public function toString():String {
		return "§*- " + MvcTraceActions.MEDIATORMAP_UNMEDIATE + " > viewObject : " + viewObject + "     {" + moduleName + "}";
	}

}
}