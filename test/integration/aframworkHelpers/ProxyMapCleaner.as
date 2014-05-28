package integration.aframworkHelpers {
import flash.utils.Dictionary;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.ProxyMap;

/**
 * ...
 * @author Deril
 */
public class ProxyMapCleaner extends ProxyMap {
	
	public static function clear() {
		qualifiedClassNameRegistry = new Dictionary();
		classInjectRules = new Dictionary();
	}
	
	public function ProxyMapCleaner() {
		super(null, null);
	}

}

}