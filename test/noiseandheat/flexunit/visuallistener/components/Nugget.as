/**
 * Licensed under the MIT license:
 *
 *     http://www.opensource.org/licenses/mit-license.php
 *
 * (c) Copyright 2011 David Wagner.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package noiseandheat.flexunit.visuallistener.components {
import flash.display.LineScaleMode;
import flash.display.Sprite;

import org.flexunit.runner.IDescription;

/**
 * Test result nugget. Used to display the current state of a test.
 */
public class Nugget extends Sprite {
	protected static const INNER_X:int = 2;
	protected static const INNER_Y:int = 2;
	protected static const INNER_W:int = 12;
	protected static const INNER_H:int = 12;

	public static const WIDTH:int = INNER_W + INNER_X + INNER_X;
	public static const HEIGHT:int = INNER_W + INNER_Y + INNER_Y;

	public static const STATE_UNCERTAIN:int = 0;
	public static const STATE_IGNORED:int = 1;
	public static const STATE_STARTED:int = 2;
	public static const STATE_FINISHED_SUCCESS:int = 3;
	public static const STATE_FINISHED_FAILURE:int = 4;
	public static const STATE_RUN_STARTED:int = 5;
	public static const STATE_RUN_FINISHED_SUCCESS:int = 6;
	public static const STATE_RUN_FINISHED_FAILURE:int = 7;
	public static const STATE_FAILURE:int = 8;
	public static const STATE_ASSUMPTION_FAILURE:int = 9;
	public static const STATE_SUITE:int = 10;
	public static const STATE_FINISHED:int = 10;

	protected var description:IDescription;
	protected var _state:int;
	protected var _message:String;
	protected var _stackTrace:String;
	protected var _overrideDisplayName:String;

	public function Nugget(description:IDescription) {
		mouseChildren = false;

		_message = "";
		_stackTrace = "";

		this._state = STATE_UNCERTAIN;
		this.description = description;
		_message = "";
		_stackTrace = "";
		drawBase();
		update();
	}

	public function set state(value:int):void {
		if (value != _state) {
			_state = value;
			update();
		}
	}

	public function get state():int {
		return _state;
	}

	protected function drawBase():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0xffffff, 1.0);
		graphics.drawRect(INNER_X - 2, INNER_Y - 2, INNER_W + 4, INNER_H + 4);
		graphics.endFill();

		graphics.beginFill(0x000000, 1.0);
		graphics.drawRect(INNER_X - 1, INNER_Y - 1, INNER_W + 2, INNER_H + 2);
		graphics.endFill();
	}

	protected function drawUncertain():void {
	}

	protected function drawIgnored():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0xcccccc, 1.0);
		graphics.drawRect(INNER_X, INNER_Y, INNER_W, INNER_H);
		graphics.endFill();
	}

	protected function drawStarted():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0x00ff00, 1.0);
		graphics.drawEllipse(INNER_X, INNER_Y, INNER_W, INNER_H);
		graphics.endFill();
	}

	protected function drawFinishedSuccess():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0x00ff00, 1.0);
		graphics.drawEllipse(INNER_X, INNER_Y, INNER_W, INNER_H);
		graphics.endFill();
	}

	protected function drawFinishedFailure():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0xff0000, 1.0);
		graphics.drawEllipse(INNER_X, INNER_Y, INNER_W, INNER_H);
		graphics.endFill();
	}

	protected function drawRunStarted():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0xffcc00, 1.0);
		graphics.drawRect(INNER_X + INNER_W / 2, INNER_Y, INNER_W / 2, INNER_H);
		graphics.endFill();
	}

	protected function drawRunFinishedSuccess():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0x00ff00, 1.0);
		graphics.drawRect(INNER_X, INNER_Y, INNER_W / 2, INNER_H);
		graphics.endFill();

		graphics.beginFill(0x000000, 1.0);
		graphics.drawRect(INNER_X + INNER_W / 2, INNER_Y, INNER_W / 2, INNER_H);
		graphics.endFill();
	}

	protected function drawRunFinishedFailure():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0xff0000, 1.0);
		graphics.drawRect(INNER_X, INNER_Y, INNER_W / 2, INNER_H);
		graphics.endFill();

		graphics.beginFill(0x000000, 1.0);
		graphics.drawRect(INNER_X + INNER_W / 2, INNER_Y, INNER_W / 2, INNER_H);
		graphics.endFill();
	}

	protected function drawFailure():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0xff0000, 1.0);
		graphics.drawEllipse(INNER_X, INNER_Y, INNER_W, INNER_H);
		graphics.endFill();
	}

	protected function drawAssumptionFailure():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0xff0000, 1.0);
		graphics.drawRect(INNER_X, INNER_Y, INNER_W, INNER_H);
		graphics.endFill();
	}

	protected function drawSuite():void {
	}

	protected function drawFinished():void {
		graphics.lineStyle(1, 0x000000, 0, true, LineScaleMode.NONE);

		graphics.beginFill(0xffffff, 1.0);
		graphics.drawRect(INNER_X, INNER_Y, INNER_W, INNER_H);
		graphics.endFill();
	}

	public function update():void {
		switch (_state) {
			case STATE_IGNORED:
				drawIgnored();
				break;
			case STATE_STARTED:
				drawStarted();
				break;
			case STATE_FINISHED_SUCCESS:
				drawFinishedSuccess();
				break;
			case STATE_FINISHED_FAILURE:
				drawFinishedFailure();
				break;
			case STATE_RUN_STARTED:
				drawRunStarted();
				break;
			case STATE_RUN_FINISHED_SUCCESS:
				drawRunFinishedSuccess();
				break;
			case STATE_RUN_FINISHED_FAILURE:
				drawRunFinishedFailure();
				break;
			case STATE_FAILURE:
				drawFailure();
				break;
			case STATE_ASSUMPTION_FAILURE:
				drawAssumptionFailure();
				break;
			case STATE_SUITE:
				drawSuite();
				break;
			case STATE_FINISHED:
				drawFinished();
				break;
			case STATE_UNCERTAIN:
			default:
				drawUncertain();
				break;
		}
	}

	public function get message():String {
		return _message;
	}

	public function set message(message:String):void {
		_message = message || "";
	}

	public function get stackTrace():String {
		return _stackTrace;
	}

	public function set stackTrace(stackTrace:String):void {
		_stackTrace = stackTrace || "";
	}

	public function set displayName(name:String):void {
		_overrideDisplayName = name;
	}

	public function get displayName():String {
		if (_overrideDisplayName) {
			return _overrideDisplayName;
		}
		else if (description && description.displayName) {
			return description.displayName;
		}
		else {
			return "No display name";
		}

	}

	override public function toString():String {
		return "[" + displayName + "] " + message;
	}

	public function toFullString():String {
		var message:String = toString();

		if (_stackTrace) {
			message += "\n";
			message += (_stackTrace ? ": " + _stackTrace : "");
			message += "\n";
		}

		return message;
	}
}
}
