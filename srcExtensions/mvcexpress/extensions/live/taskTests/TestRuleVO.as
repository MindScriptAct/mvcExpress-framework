// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.taskTests {
import mvcexpress.extensions.live.core.inject.InjectRuleTaskVO;

/**
 * FOR INTERNAL USE ONLY.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version live.1.0.beta2
 */
public class TestRuleVO extends InjectRuleTaskVO {

	public var functionName:String;

	public var testDelay:int = 0;

	public var testCount:int = 1;

}
}