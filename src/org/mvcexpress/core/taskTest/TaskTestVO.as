package org.mvcexpress.core.taskTest {
import org.mvcexpress.core.inject.TestRuleVO;

/**
 * INTERNAL.
 * @author rBanevicius
 */
public class TaskTestVO {
	
	public var testFunction:Function;
	
	public var totalCount:int;
	
	public var totalDelay:int;
	
	public var currentTimer:uint;

	public var currentDelay:int = 0;
}
}