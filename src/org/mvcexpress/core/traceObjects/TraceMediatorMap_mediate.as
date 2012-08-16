// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import flash.display.DisplayObject;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMediatorMap_mediate extends TraceObj {
	public var viewObject:Object;
	public var mediatorObject:Mediator;
	public var viewClass:Class;
	public var mediatorClass:Class;
	public var mediatorClassName:String;
	
	public var view:DisplayObject;
	public var dependencies:Vector.<Object>;
	
	public var handleObjects:Vector.<Object>;
	
	public function TraceMediatorMap_mediate(action:String, moduleName:String, viewObject:Object, mediatorObject:Mediator, viewClass:Class, mediatorClass:Class, mediatorClassName:String) {
		super(action, moduleName);
		this.viewObject = viewObject;
		this.mediatorObject = mediatorObject;
		this.viewClass = viewClass;
		this.mediatorClass = mediatorClass;
		this.mediatorClassName = mediatorClassName;
	}
	
	override public function toString():String {
		return "§*+ " + MvcTraceActions.MEDIATORMAP_MEDIATE + " > viewObject : " + viewObject + " (viewClass:" + viewClass + ")" + " WITH > mediatorClass : " + mediatorClass + "     {" + moduleName + "}";
	}

}
}