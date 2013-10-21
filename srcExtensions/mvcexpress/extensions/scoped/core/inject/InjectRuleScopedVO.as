// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.core.inject {
import mvcexpress.core.inject.InjectRuleVO;

/**
 * FOR INTERNAL USE ONLY.
 * Value Object to keep injection rules - what have to be injected there.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version scoped.1.0.beta2
 */
public class InjectRuleScopedVO extends InjectRuleVO {

	/** FOR INTERNAL USE ONLY. Scope name for injection. */
	public var scopeName:String;

	CONFIG::debug
	override public function toString():String {
		return "[InjectRuleVO varName=" + varName + " injectClassAndName=" + injectClassAndName + " scopeName=" + scopeName + "]";
	}
}
}