package com.mindscriptact.mvcExpressLogger {
import com.bit101.components.CheckBox;
import com.bit101.components.NumericStepper;
import com.bit101.components.PushButton;
import com.bit101.components.Style;
import com.bit101.components.Text;
import com.bit101.components.Window;
import com.mindscriptact.mvcExpressLogger.screens.MvcExpressLogScreen;
import com.mindscriptact.mvcExpressLogger.screens.MvcExpressVisualizerScreen;
import com.mindscriptact.mvcExpressLogger.visualizer.VisualizerManager;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.setTimeout;
import org.mvcexpress.core.ModuleManager;
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
	static private const VISUALIZER_LABEL:String = "VISUALIZER";
	//
	static private var allowInstantiation:Boolean;
	static private var instance:MvcExpressLogger;
	static private var visualizerManager:VisualizerManager;
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
	private var currentModuleName:String = "";
	private var moduleStepper:NumericStepper;
	private var currentModuleText:Text;
	private var allModuleNames:Array;
	private var isRenderWaiting:Boolean = false;
	private var autoLogCheckBox:CheckBox;
	private var useAutoScroll:Boolean = true;
	
	public function MvcExpressLogger() {
		if (!allowInstantiation) {
			throw Error("MvcExpressLogger is singleton and will be instantiated with first use or MvcExpressLogger.init() or MvcExpressLogger.showIn()");
		}
	}
	
	static public function init(stage:Stage, x:int = 0, y:int = 0, width:int = 600, height:int = 400, alpha:Number = 0.9, autoShow:Boolean = false, openKeyCode:int = 192, isCtrlKeyNeeded:Boolean = true, isShiftKeyNeeded:Boolean = false, isAltKeyNeeded:Boolean = false):void {
		
		if (!instance) {
			allowInstantiation = true;
			instance = new MvcExpressLogger();
			allowInstantiation = false;
			//
			visualizerManager = new VisualizerManager();
			//
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
		
		MvcExpress.debugFunction = instance.debugMvcExpress;
		MvcExpress.loggerFunction = visualizerManager.logMvcExpress;
		
		if (autoShow) {
			instance.showLogger();
		}
	}
	
	static public function show():void {
		if (instance) {
			instance.showLogger();
		} else {
			trace("WARNING: MvcExpressLogger must be MvcExpressLogger.init(); before you can use this function.");
		}
	}
	
	static public function hide():void {
		if (instance) {
			instance.showLogger();
		} else {
			trace("WARNING: MvcExpressLogger must be MvcExpressLogger.init(); before you can use this function.");
		}
	}
	
	private function debugMvcExpress(msg:String):void {
		// TODO: refactor
		logText += msg + "\n";
		//
		if (isLogShown) {
			
			var logType:String = msg.substr(0, 2);
			
			if (logType == "##") {
				setTimeout(resolveCurrentModuleName, 1);
			} else {
				switch (currentTabButtonName) {
					case LOG_LABEL: 
						render();
						break;
					case MESSAGES_LABEL: 
						if (logType == "••" || logType == "•>") {
							if (!isRenderWaiting) {
								isRenderWaiting = true;
								setTimeout(render, 1);
							}
						}
						break;
					case MEDIATORS_LABEL: 
						if (logType == "§§") {
							if (!isRenderWaiting) {
								isRenderWaiting = true;
								setTimeout(render, 1);
							}
						}
						break;
					case PROXIES_LABEL: 
						if (logType == "¶¶") {
							if (!isRenderWaiting) {
								isRenderWaiting = true;
								setTimeout(render, 1);
							}
						}
						break;
					case COMMANDS_LABEL: 
						if (logType == "©©") {
							if (!isRenderWaiting) {
								isRenderWaiting = true;
								setTimeout(render, 1);
							}
						}
						break;
					case VISUALIZER_LABEL: 
						break;
					default: 
				}
			}
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
			
			//
			
			moduleStepper = new NumericStepper(logWindow, 120, 5, handleModuleChange);
			moduleStepper.width = 32;
			moduleStepper.minimum = 0;
			moduleStepper.isCircular = true;
			
			currentModuleText = new Text(logWindow, 0, 0, "...");
			currentModuleText.editable = false;
			currentModuleText.width = 120;
			currentModuleText.height = 22
			
			var rectangle:Shape = new Shape();
			rectangle.graphics.lineStyle(1, 0xFFFFFF);
			rectangle.graphics.drawRect(0, 0, 120, 22);
			logWindow.addChild(rectangle);
			
			allButtons = new Vector.<PushButton>();
			
			var logButton:PushButton = new PushButton(logWindow, 0, -0, LOG_LABEL, handleButtonClick);
			logButton.toggle = true;
			logButton.width = 50;
			logButton.x = moduleStepper.x + moduleStepper.width + 10;
			allButtons.push(logButton);
			
			var messageMapingButton:PushButton = new PushButton(logWindow, 0, -0, MESSAGES_LABEL, handleButtonClick);
			messageMapingButton.toggle = true;
			messageMapingButton.width = 60;
			messageMapingButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 5;
			allButtons.push(messageMapingButton);
			
			var mediatorMapingButton:PushButton = new PushButton(logWindow, 0, -0, MEDIATORS_LABEL, handleButtonClick);
			mediatorMapingButton.toggle = true;
			mediatorMapingButton.width = 60;
			mediatorMapingButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 5;
			allButtons.push(mediatorMapingButton);
			
			var proxyMapingButton:PushButton = new PushButton(logWindow, 0, -0, PROXIES_LABEL, handleButtonClick);
			proxyMapingButton.toggle = true;
			proxyMapingButton.width = 50;
			proxyMapingButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 5;
			allButtons.push(proxyMapingButton);
			
			var commandMapingButton:PushButton = new PushButton(logWindow, 0, -0, COMMANDS_LABEL, handleButtonClick);
			commandMapingButton.toggle = true;
			commandMapingButton.width = 60;
			commandMapingButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 5;
			allButtons.push(commandMapingButton);
			
			var clearButton:PushButton = new PushButton(logWindow, 0, 5, "clear log", handleClearLog);
			clearButton.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 10;
			clearButton.width = 50;
			clearButton.height = 15;
			
			autoLogCheckBox = new CheckBox(logWindow, 0, 5, "autoScroll", handleAutoScrollTogle);
			autoLogCheckBox.x = allButtons[allButtons.length - 1].x + allButtons[allButtons.length - 1].width + 70;
			autoLogCheckBox.selected = true;
			
			var visualizerButton:PushButton = new PushButton(logWindow, 0, -0, VISUALIZER_LABEL, handleButtonClick);
			visualizerButton.toggle = true;
			visualizerButton.width = 60;
			visualizerButton.x = 600;
			allButtons.push(visualizerButton);
			
		}
		//forceThisOnTop();
		stage.addChild(logWindow);
		
		resolveCurrentModuleName();
		
		handleButtonClick();
	}
	
	private function handleClearLog(event:MouseEvent):void {
		trace("MvcExpressLogger.handleClearLog > event : " + event);
		logText = "";
		render();
	}
	
	private function handleAutoScrollTogle(event:MouseEvent):void {
		trace("MvcExpressLogger.handleAutoScrollTogle > event : " + event);
		
		useAutoScroll = (event.target as CheckBox).selected;
		(currentScreen as MvcExpressLogScreen).scrollDown(useAutoScroll);
	}
	
	private function resolveCurrentModuleName():void {
		var moduleNameList:String = ModuleManager.listModules();
		var namesOnly:Array = moduleNameList.split(":");
		if (namesOnly.length > 1) {
			allModuleNames = namesOnly[1].split(",");
			if (currentModuleName) {
				if (moduleStepper.value > 0) {
					if (allModuleNames[moduleStepper.value - 1] == currentModuleName) {
						moduleStepper.value -= 1;
					} else if (moduleStepper.value >= allModuleNames.length || allModuleNames[moduleStepper.value] != currentModuleName) {
						moduleStepper.value = 0;
						currentModuleName = allModuleNames[0];
					}
				}
				
			} else {
				currentModuleName = allModuleNames[0];
			}
			
			currentModuleText.text = currentModuleName;
		}
		moduleStepper.maximum = allModuleNames.length - 1;
		
		currentModuleName = currentModuleName;
		
		render();
	}
	
	private function handleModuleChange(event:Event):void {
		currentModuleName = allModuleNames[moduleStepper.value];
		currentModuleText.text = currentModuleName;
		visualizerManager.manageThisScreen(currentModuleName, currentScreen as MvcExpressVisualizerScreen);
		render();
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
			
			autoLogCheckBox.visible = (currentTabButtonName == LOG_LABEL)
			
			switch (currentTabButtonName) {
				case VISUALIZER_LABEL: 
					currentScreen = new MvcExpressVisualizerScreen(width - 6, height - 52);
					currentScreen.x = 3;
					currentScreen.y = 25;
					visualizerManager.manageThisScreen(currentModuleName, currentScreen as MvcExpressVisualizerScreen);
					break;
				default: 
					currentScreen = new MvcExpressLogScreen(width - 6, height - 52);
					currentScreen.x = 3;
					currentScreen.y = 25;
					visualizerManager.manageNothing();
					break;
			}
			render();
			if (currentScreen) {
				logWindow.addChild(currentScreen);
				
			}
		} else {
			currentTogleButton.selected = true;
		}
	
	}
	
	private function render():void {
		isRenderWaiting = false;
		
		switch (currentTabButtonName) {
			case LOG_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(logText);
				(currentScreen as MvcExpressLogScreen).scrollDown(useAutoScroll);
				break;
			case MESSAGES_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(ModuleManager.listMappedMessages(currentModuleName));
				(currentScreen as MvcExpressLogScreen).scrollDown(false);
				break;
			case MEDIATORS_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(ModuleManager.listMappedMediators(currentModuleName));
				(currentScreen as MvcExpressLogScreen).scrollDown(false);
				break;
			case PROXIES_LABEL: 
				(currentScreen as MvcExpressLogScreen).showLog(ModuleManager.listMappedProxies(currentModuleName));
				(currentScreen as MvcExpressLogScreen).scrollDown(false);
				break;
			case COMMANDS_LABEL:
				(currentScreen as MvcExpressLogScreen).showLog(ModuleManager.listMappedCommands(currentModuleName));
				(currentScreen as MvcExpressLogScreen).scrollDown(false);
				break;
			case VISUALIZER_LABEL:
				
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