package org.pureLegs.core.inject {

/**
 * Value Object to keep injection rules(what have to be injected there...).
 * @author rbanevicius
 */
public class InjectRuleVO {
	
	/** variable name  */
	public var varName:String;
	
	/**  class(with type) name that has to be injected */
	public var injectClassName:String;

}
}