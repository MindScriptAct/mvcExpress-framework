package com.mindscriptact.mvcExpressLogger {
import com.bit101.components.PushButton;
import com.bit101.components.Style;
import com.bit101.components.Window;
import com.mindscriptact.mvcExpressLogger.screens.MvcExpressLogScreen;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import org.mvcexpress.modules.ModuleCore;
import org.mvcexpress.MvcExpress;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MvcExpressLogger {
	
	static private const LOG_LABEL:String = "LOG";
	static private const MESSAGES_LABEL:String = "MESSAGES";
	static private const MEDIATORS_LABEL:String = "MEDIATORS";
	static private const PROXIES_LABEL:String = "PROXIES";
	static private const COMMANDS_LABEL:String = "COMMANDS";
	//
	static private var allowInstantiation:Boolean;
	static private var instance:MvcExpressLogger;
	//
	private var mainModule:ModuleCore;
	// view params
	private var stage:Stage;
	private var x:int;
	private var y:int;
	private var width:int;
	private var height:int;
	private var alpha:Number;
	private var openKeyCode:int;
	private var isCtrlKeyNeeded:Boolean;
	private var isShiftKeyNeeded:Boolean;
	private var isAltKeyNeeded:Boolean;
	//
	// view
	private var logWindow:Window;
	private var isLogShown:Boolean = false;
	private var allButtons:Vector.<PushButton>;
	private var currentScreen:Sprite;
	private var currentTogleButton:PushButton;
	private var currentTabButtonName:String;
	//
	private var logText:String = "";
	
	public function MvcExpressLogger() {
		if (!allowInstantiation) {
			throw Error("MvcExpressLogger is singleton and will be instantiated with first use or MvcExpressLogger.logModule() or MvcExpressLogger.showIn()");
		}
	}
	
	static public function logModule(module:ModuleCore):void {
		if (!instance) {
			allowInstantiation = true;
			instance = new MvcExpressLogger();
			allowInstantiation = false;
		}
		instance.mainModule = module;
		MvcExpress.debugFunction = instance.traceMvcExpress
	}
	
	static public function showIn(stage:Stage, x:int = 0, y:int = 0, width:int = 600, height:int = 400, alpha:Number = 0.9, openKeyCode:int = 192, isCtrlKeyNeeded:Boolean = true, isShiftKeyNeeded:Boolean = false, isAltKeyNeeded:Boolean = false):void {
		if (!instance) {
			allowInstantiation = true;
			instance = new MvcExpressLogger();
			allowInstantiation = false;
		}
		instance.stage = stage;
		stage.root.addEventListener(KeyboardEvent.KEY_DOWN, instance.handleKeyPress);
		
		instance.x = x;
		instance.y = y;
		instance.width = width;
		instance.height = height;
		instance.alpha = alpha;
		instance.openKeyCode = openKeyCode;
		instance.isCtrlKeyNeeded = isCtrlKeyNeeded;
		instance.isShiftKeyNeeded = isShiftKeyNeeded;
		instance.isAltKeyNeeded = isAltKeyNeeded;
		Style.setStyle(Style.DARK);
		Style.LABEL_TEXT = 0xFFFFFF;
	}
	
	private function traceMvcExpress(msg:String):void {
		// TODO: refactor
		logText += msg + "\n";
		//
		if (isLogShown) {
			render();
		}
	}
	
	private function handleKeyPress(event:KeyboardEvent):void {
		//trace("MvcExpressLogger.handleKeyPress > event : " + event);
		if (event.keyCode == openKeyCode && event.ctrlKey == isCtrlKeyNeeded && event.shiftKey == isShiftKeyNeeded && event.altKey == isAltKeyNeeded) {
			if (!isLogShown) {
				showLogger();
			} else {
				hideLogger();
			}
		}
	}
	
	private function showLogger():void {
		isLogShown = true;
		if (!logWindow) {
			logWindow = new Window(null, x, y, "mvcExpress logger");
			logWindow.width = width;
			logWindow.height = height
			logWindow.alpha = alpha;
			logWindow.hasCloseButton = true;
			logWindow.addEventListener(Event.CLOSE, hideLogger);
			
			allButtons = new Vector.<PushButton>();
			
			var logButton:PushButton = new PushButton(logWindow, 0, -0, LOG_LABEL, handleButtonClick);
			logButton.toggle = true;
			logButton.width = 100;
			allButtons.push(logButton);
			
			var messageMapingButton:PushButton = new PushButton(logWindow, 0, -0, MESSAGES_LABEL, handleButtonClick);
			messageMapingButton.toggle = true;
			messageMapingButton.width = 100;
			messageMapingButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 5;
			allButtons.push(messageMapingButton);
			
			var mediatorMapingButton:PushButton = new PushButton(logWindow, 0, -0, MEDIATORS_LABEL, handleButtonClick);
			mediatorMapingButton.toggle = true;
			mediatorMapingButton.width = 100;
			mediatorMapingButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 5;
			allButtons.push(mediatorMapingButton);
			
			var proxyMapingButton:PushButton = new PushButton(logWindow, 0, -0, PROXIES_LABEL, handleButtonClick);
			proxyMapingButton.toggle = true;
			proxyMapingButton.width = 100;
			proxyMapingButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 5;
			allButtons.push(proxyMapingButton);
			
			var commandMapingButton:PushButton = new PushButton(logWindow, 0, -0, COMMANDS_LABEL, handleButtonClick);
			commandMapingButton.toggle = true;
			commandMapingButton.width = 100;
			commandMapingButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 5;
			allButtons.push(commandMapingButton);
			
		}
		//forceThisOnTop();
		stage.addChild(logWindow);
		
		handleButtonClick();
	}
	
	private function handleButtonClick(event:MouseEvent = null):void {
		if (event) {
			var targetButton:PushButton = (event.target as PushButton);
		} else {
			targetButton = allButtons[0];
			targetButton.selected = true;
		}
		
		if (currentTogleButton != targetButton) {
			currentTogleButton = targetButton;
			
			for (var i:int = 0; i < allButtons.length; i++) {
				if (allButtons[i] != targetButton) {
					allButtons[i].selected = false;
				}
			}
			if (currentScreen) {
				logWindow.removeChild(currentScreen);
				currentScreen = null;
			}
			currentTabButtonName = targetButton.label;
			switch (currentTabButtonName) {
				default: 
					currentScreen = new MvcExpressLogScreen(width - 6, height - 52);
					currentScreen.x = 3;
					currentScreen.y = 25;
					render();
			}
			if (currentScreen) {
				logWindow.addChild(currentScreen);
				
			}
		} else {
			currentTogleButton.selected = true;
		}
	
	}
	
	private function render():void {
		switch (currentTabButtonName) {
			case LOG_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(logText);
				//(currentScreen as MvcExpressLogScreen).scrollDown();
				break;
			case MESSAGES_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(mainModule.listMappedMessages());
				break;
			case MEDIATORS_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(mainModule.listMappedMediators());
				break;
			case PROXIES_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(mainModule.listMappedProxies());
				break;
			case COMMANDS_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(mainModule.listMappedCommands());
				break;
			default: 
		}
	}
	
	private function hideLogger(event:Event = null):void {
		isLogShown = false;
		stage.removeChild(logWindow);
	}

}
}