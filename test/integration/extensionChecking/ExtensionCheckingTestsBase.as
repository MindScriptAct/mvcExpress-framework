package integration.extensionChecking {
import flash.display.Sprite;
import integration.aframworkHelpers.ProxyMapCleaner;

import integration.aGenericTestObjects.GenericTestModule;

import mvcexpress.core.ModuleManager;
import mvcexpress.modules.ModuleCore;

public class ExtensionCheckingTestsBase {


	protected var extensionModuleClass:Class;

	protected var extensionCommandMapClass:Class;
	protected var extensionProxyMapClass:Class;
	protected var extensionMediatorMapClass:Class;

	protected var extensionMessendegClass:Class;

	protected var extensionCommandClass:Class;
	protected var extensionProxyClass:Class;
	protected var extensionMediatorClass:Class;


	private var moduleCore:ModuleCore;
	private var genericModule:GenericTestModule;

	private var genericExtensionModule:ModuleCore;

	[Before]
	public function runBeforeEveryTest():void {
		if (moduleCore) {
			moduleCore.disposeModule();
		}
		if (genericModule) {
			genericModule.disposeModule();
		}
		if (genericExtensionModule) {
			genericExtensionModule.disposeModule();
		}
	}

	[After]
	public function runAfterEveryTest():void {
		
		ProxyMapCleaner.clear();
		
		if (moduleCore) {
			moduleCore.disposeModule();
		}
		if (genericModule) {
			genericModule.disposeModule();
		}
		if (genericExtensionModule) {
			genericExtensionModule.disposeModule();
		}
		ModuleManager.disposeAll();
	}

	[Test]
	public function extensionChecking_goodMediatorMap_ok():void {
		CONFIG::debug {
			moduleCore = new extensionModuleClass("test", extensionMediatorMapClass);
		}
	}

	[Test]
	public function extensionChecking_goodProxyMap_ok():void {
		CONFIG::debug {
			moduleCore = new extensionModuleClass("test", null, extensionProxyMapClass);
		}
	}

	[Test]
	public function extensionChecking_goodCommandMap_ok():void {
		CONFIG::debug {
			moduleCore = new extensionModuleClass("test", null, null, extensionCommandMapClass);
		}
	}

	[Test]
	public function extensionChecking_goodMessanger_ok():void {
		CONFIG::debug {
			moduleCore = new extensionModuleClass("test", null, null, null, extensionMessendegClass);
		}
	}


	[Test(expects="Error")]
	public function extensionChecking_badMediatorMap_fails():void {
		CONFIG::debug {
			moduleCore = new ModuleCore("test", extensionMediatorMapClass);
		}
		if (!moduleCore) {
			throw Error("SKIP.");
		}
	}

	[Test(expects="Error")]
	public function extensionChecking_badProxyMap_fails():void {
		CONFIG::debug {
			moduleCore = new ModuleCore("test", null, extensionProxyMapClass);
		}
		if (!moduleCore) {
			throw Error("SKIP.");
		}
	}

	[Test(expects="Error")]
	public function extensionChecking_badCommandMap_fails():void {
		CONFIG::debug {
			moduleCore = new ModuleCore("test", null, null, extensionCommandMapClass);
		}
		if (!moduleCore) {
			throw Error("SKIP.");
		}
	}

	[Test(expects="Error")]
	public function extensionChecking_badMessanger_fails():void {
		CONFIG::debug {
			moduleCore = new ModuleCore("test", null, null, null, extensionMessendegClass);
		}
		if (!moduleCore) {
			throw Error("SKIP.");
		}
	}


	//-------------------------------
	//  mediator mapping - fail
	//-------------------------------

	[Test(expects="Error")]
	public function extensionChecking_badMediator_mapFunct_fails():void {
		CONFIG::debug {
			genericModule = new GenericTestModule();
			genericModule.mediatorMap_map(Sprite, extensionMediatorClass);
		}
		if (!genericModule) {
			throw Error("SKIP.");
		}
	}

	[Test(expects="Error")]
	public function extensionChecking_badMediator_mediateWithFunct_fails():void {
		CONFIG::debug {
			genericModule = new GenericTestModule();
			genericModule.mediatorMap_mediateWith(new Sprite(), extensionMediatorClass);
		}
		if (!genericModule) {
			throw Error("SKIP.");
		}
	}


	//-------------------------------
	//  proxy mapping - fail
	//-------------------------------

	[Test(expects="Error")]
	public function extensionChecking_badProxy_mapFunct_fails():void {
		CONFIG::debug {
			genericModule = new GenericTestModule();
			genericModule.proxymap_map(new extensionProxyClass());
		}
		if (!genericModule) {
			throw Error("SKIP.");
		}
	}

	[Test(expects="Error")]
	public function extensionChecking_badProxy_lazyMapFunct_fails():void {
		CONFIG::debug {
			genericModule = new GenericTestModule();
			genericModule.proxymap_lazyMap(extensionProxyClass);
		}
		if (!genericModule) {
			throw Error("SKIP.");
		}
	}

	//-------------------------------
	//  command mapping - fail
	//-------------------------------

	[Test(expects="Error")]
	public function extensionChecking_badCommand_mapFunct_fails():void {
		CONFIG::debug {
			genericModule = new GenericTestModule();
			genericModule.commandMap_map("test", extensionCommandClass);
		}
		if (!genericModule) {
			throw Error("SKIP.");
		}
	}

	//-------------------------------
	//  command execution - fail
	//-------------------------------

	[Test(expects="Error")]
	public function extensionChecking_badCommand_executeFunct_fails():void {
		CONFIG::debug {
			genericModule = new GenericTestModule();
			genericModule.commandMap_execute(extensionCommandClass);
		}
		if (!genericModule) {
			throw Error("SKIP.");
		}
	}


	//-------------------------------
	//  mediator mapping - ok
	//-------------------------------

	[Test]
	public function extensionChecking_badMediator_mapFunct_ok():void {
		CONFIG::debug {
			genericExtensionModule = new extensionModuleClass();
			genericExtensionModule['mediatorMap_map'](Sprite, extensionMediatorClass);
		}
	}

	[Test]
	public function extensionChecking_badMediator_mediateWithFunct_ok():void {
		CONFIG::debug {
			genericExtensionModule = new extensionModuleClass();
			genericExtensionModule['mediatorMap_mediateWith'](new Sprite(), extensionMediatorClass);
		}
	}


	//-------------------------------
	//  proxy mapping - ok
	//-------------------------------

	[Test]
	public function extensionChecking_badProxy_mapFunct_ok():void {
		CONFIG::debug {
			genericExtensionModule = new extensionModuleClass();
			genericExtensionModule['proxymap_map'](new extensionProxyClass());
		}
	}

	[Test]
	public function extensionChecking_badProxy_lazyMapFunct_ok():void {
		CONFIG::debug {
			genericExtensionModule = new extensionModuleClass();
			genericExtensionModule['proxymap_lazyMap'](extensionProxyClass);
		}
	}

	//-------------------------------
	//  command mapping - ok
	//-------------------------------

	[Test]
	public function extensionChecking_badCommand_mapFunct_ok():void {
		CONFIG::debug {
			genericExtensionModule = new extensionModuleClass();
			genericExtensionModule['commandMap_map']("test", extensionCommandClass);
		}
	}

	//-------------------------------
	//  command execution - ok
	//-------------------------------

	[Test]
	public function extensionChecking_badCommand_executeFunct_ok():void {
		CONFIG::debug {
			genericExtensionModule = new extensionModuleClass();
			genericExtensionModule['commandMap_execute'](extensionCommandClass);
		}
	}


}
}
