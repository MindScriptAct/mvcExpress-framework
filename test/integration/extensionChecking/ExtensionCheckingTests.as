package integration.extensionChecking {
import flash.display.Sprite;

import integration.aGenericExtension.GenericTestExtensionModule;

import integration.aGenericExtension.core.CommandMapExtensionTest;
import integration.aGenericExtension.core.MediatorMapExtensionTest;
import integration.aGenericExtension.core.MessengerExtensionTest;
import integration.aGenericExtension.core.ProxyMapExtensionTest;
import integration.aGenericExtension.module.ModuleExtensionTest;
import integration.aGenericExtension.mvc.CommnadExstensionTest;
import integration.aGenericExtension.mvc.MediatorExtensionTest;
import integration.aGenericExtension.mvc.ProxyExtensionTest;
import integration.aGenericTestObjects.GenericTestModule;

import mvcexpress.core.ModuleManager;
import mvcexpress.modules.ModuleCore;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTests {

	private var moduleCore:ModuleCore;
	private var genericModule:GenericTestModule;
	private var genericExtensionModule:GenericTestExtensionModule;

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
		moduleCore = new ModuleExtensionTest("test", MediatorMapExtensionTest);
	}

	[Test]
	public function extensionChecking_goodProxyMap_ok():void {
		moduleCore = new ModuleExtensionTest("test", null, ProxyMapExtensionTest);
	}

	[Test]
	public function extensionChecking_goodCommandMap_ok():void {
		moduleCore = new ModuleExtensionTest("test", null, null, CommandMapExtensionTest);
	}

	[Test]
	public function extensionChecking_goodMessanger_ok():void {
		moduleCore = new ModuleExtensionTest("test", null, null, null, MessengerExtensionTest);
	}


	[Test(expects="Error")]
	public function extensionChecking_badMediatorMap_fails():void {
		moduleCore = new ModuleCore("test", MediatorMapExtensionTest);
	}

	[Test(expects="Error")]
	public function extensionChecking_badProxyMap_fails():void {
		moduleCore = new ModuleCore("test", null, ProxyMapExtensionTest);
	}

	[Test(expects="Error")]
	public function extensionChecking_badCommandMap_fails():void {
		moduleCore = new ModuleCore("test", null, null, CommandMapExtensionTest);
	}

	[Test(expects="Error")]
	public function extensionChecking_badMessanger_fails():void {
		moduleCore = new ModuleCore("test", null, null, null, MessengerExtensionTest);
	}


	//-------------------------------
	//  mediator mapping - fail
	//-------------------------------

	[Test(expects="Error")]
	public function extensionChecking_badMediator_mapFunct_fails():void {
		genericModule = new GenericTestModule();
		genericModule.mediatorMap_map(Sprite, MediatorExtensionTest);
	}

	[Test(expects="Error")]
	public function extensionChecking_badMediator_mediateWithFunct_fails():void {
		genericModule = new GenericTestModule();
		genericModule.mediatorMap_mediateWith(new Sprite(), MediatorExtensionTest);
	}


	//-------------------------------
	//  proxy mapping - fail
	//-------------------------------

	[Test(expects="Error")]
	public function extensionChecking_badProxy_mapFunct_fails():void {
		genericModule = new GenericTestModule();
		genericModule.proxymap_map(new ProxyExtensionTest());
	}

	[Test(expects="Error")]
	public function extensionChecking_badProxy_lazyMapFunct_fails():void {
		genericModule = new GenericTestModule();
		genericModule.proxymap_lazyMap(ProxyExtensionTest);
	}

	//-------------------------------
	//  command mapping - fail
	//-------------------------------

	[Test(expects="Error")]
	public function extensionChecking_badCommand_mapFunct_fails():void {
		genericModule = new GenericTestModule();
		genericModule.commandMap_map("test", CommnadExstensionTest);
	}

	//-------------------------------
	//  command execution - fail
	//-------------------------------

	[Test(expects="Error")]
	public function extensionChecking_badCommand_executeFunct_fails():void {
		genericModule = new GenericTestModule();
		genericModule.commandMap_execute(CommnadExstensionTest);
	}





	//-------------------------------
	//  mediator mapping - ok
	//-------------------------------

	[Test]
	public function extensionChecking_badMediator_mapFunct_ok():void {
		genericExtensionModule = new GenericTestExtensionModule();
		genericExtensionModule.mediatorMap_map(Sprite, MediatorExtensionTest);
	}

	[Test]
	public function extensionChecking_badMediator_mediateWithFunct_ok():void {
		genericExtensionModule = new GenericTestExtensionModule();
		genericExtensionModule.mediatorMap_mediateWith(new Sprite(), MediatorExtensionTest);
	}


	//-------------------------------
	//  proxy mapping - ok
	//-------------------------------

	[Test]
	public function extensionChecking_badProxy_mapFunct_ok():void {
		genericExtensionModule = new GenericTestExtensionModule();
		genericExtensionModule.proxymap_map(new ProxyExtensionTest());
	}

	[Test]
	public function extensionChecking_badProxy_lazyMapFunct_ok():void {
		genericExtensionModule = new GenericTestExtensionModule();
		genericExtensionModule.proxymap_lazyMap(ProxyExtensionTest);
	}

	//-------------------------------
	//  command mapping - ok
	//-------------------------------

	[Test]
	public function extensionChecking_badCommand_mapFunct_ok():void {
		genericExtensionModule = new GenericTestExtensionModule();
		genericExtensionModule.commandMap_map("test", CommnadExstensionTest);
	}

	//-------------------------------
	//  command execution - ok
	//-------------------------------

	[Test]
	public function extensionChecking_badCommand_executeFunct_ok():void {
		genericExtensionModule = new GenericTestExtensionModule();
		genericExtensionModule.commandMap_execute(CommnadExstensionTest);
	}



}
}