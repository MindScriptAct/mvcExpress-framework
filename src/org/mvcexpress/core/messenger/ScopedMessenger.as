// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.messenger {
	
/**
 * Handles module to module communications.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ScopedMessenger extends Messenger {
	
	public function ScopedMessenger(moduleName:String) {
		super(moduleName);
	}
	
}
}