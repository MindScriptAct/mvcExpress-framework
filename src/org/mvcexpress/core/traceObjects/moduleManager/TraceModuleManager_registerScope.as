// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.traceObjects.moduleManager {
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;

/**
 * Class for mvcExpress tracing. (debug mode only)
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 * @private
 */
public class TraceModuleManager_registerScope extends TraceObj {
	
	public var scopeName:String;
	
	public var messageSending:Boolean;
	
	public var messageReceiving:Boolean;
	
	public var proxieMap:Boolean;
	
	public function TraceModuleManager_registerScope(moduleName:String, $scopeName:String, $messageSending:Boolean, $messageReceiving:Boolean, $proxieMap:Boolean) {
		super(MvcTraceActions.MODULEMANAGER_CREATEMODULE, moduleName);
		$scopeName = $scopeName;
		$messageSending = $messageSending;
		$messageReceiving = $messageReceiving;
		$proxieMap = $proxieMap;
	
	}
	
	override public function toString():String {
		return "##**++ " + MvcTraceActions.MODULEMANAGER_CREATEMODULE + " > moduleName : " + moduleName + " scopeName=" + scopeName + " messageSending=" + messageSending + " messageReceiving=" + messageReceiving + " proxieMap=" + proxieMap + "]";
	}

}
}