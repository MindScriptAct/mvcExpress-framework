package com.mindScriptAct.moduleAutoinitTest {
import mvcexpress.modules.ModuleSprite;

/**
 * COMMENT : todo
 * @author mindscriptact
 */
public class AutoInitFalseModule extends ModuleSprite {

	static public const NAME:String = "AutoInitFalseModule";

	public function AutoInitFalseModule() {
		trace( "AutoInitFalseModule.AutoInitFalseModule" );
		super(AutoInitFalseModule.NAME, false);
	}

	public function start():void {
		trace(commandMap);
		this.initModule();
		trace(commandMap);
	}

	override protected function onInit():void {
		trace( "AutoInitFalseModule.onInit" );

	}

	override protected function onDispose():void {
		trace( "AutoInitFalseModule.onDispose" );

	}

}
}