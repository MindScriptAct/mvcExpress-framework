package org.mvcexpress.base.inject {

/**
 * Value Object to keep injection rules(what have to be injected there...).
 * @author rbanevicius
 */
public class InjectRuleVO {
	
	/** Variable name to inject object into.  */
	public var varName:String;
	
	/** String for class and name that has to be injected */
	public var injectClassAndName:String;

}
}