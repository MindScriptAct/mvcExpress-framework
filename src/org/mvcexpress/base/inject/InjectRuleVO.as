// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.base.inject {

/**
 * Value Object to keep injection rules(what have to be injected there...).
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class InjectRuleVO {
	
	/** Name of variable to inject object into. */
	public var varName:String;
	
	/** Injection identifier, formed by class name and your custom inject name. */
	public var injectClassAndName:String;

}
}