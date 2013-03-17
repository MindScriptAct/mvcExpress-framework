package org.mvcexpress.extensions.viewManager {
import flash.display.DisplayObject;
import flash.display.Stage;
import com.mindScriptAct.testViewManagerExpress.ViewMenagerMainModule;
import org.mvcexpress.extensions.viewManager.vo.ViewDefinition;

/**
 * COMMENT
 * @author Deril
 */
public class ViewManagerExpress {
	
	static public function init(moduleName:String, rootViewObject:DisplayObject):ViewDefinition {
		var retVal:ViewDefinition = new ViewDefinition(null, null);
		
		return retVal;
	}
}
}