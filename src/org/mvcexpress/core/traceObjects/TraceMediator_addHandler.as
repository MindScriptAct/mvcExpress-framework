// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects {
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TraceMediator_addHandler extends TraceObj {
	
	public var type:String;
	public var handler:Function;
	public var mediatorObject:Mediator;
	
	public function TraceMediator_addHandler(action:String, moduleName:String, mediatorObject:Mediator, type:String, handler:Function) {
		super(action, moduleName);
		this.mediatorObject = mediatorObject;
		this.type = type;
		this.handler = handler;
		//
		canPrint = false;
	}

}
}