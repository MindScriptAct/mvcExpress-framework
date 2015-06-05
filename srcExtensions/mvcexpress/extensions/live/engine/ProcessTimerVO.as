package mvcexpress.extensions.live.engine {

/**
 * INTERNAL.
 * @private
 *
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class ProcessTimerVO {

    // ms passed from last tick.
	public var ms:int;

    // seconds passed from last tick.
	public var sec:Number;

    // current timer
    public var timerCurrent:int;

    // last timer
	public var timerLast:int;
}
}