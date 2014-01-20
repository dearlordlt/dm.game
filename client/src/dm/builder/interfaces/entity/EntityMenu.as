package dm.builder.interfaces.entity {
	
	import dm.builder.interfaces.components.ComponentHolder;
	import dm.builder.interfaces.components.SelectComponent;
	import dm.builder.interfaces.dropdownmenu.DropDownMenu;
	import flash.display.DisplayObjectContainer;
	import ucc.logging.Logger;
	
	/**
	 * ...
	 * @author
	 */
	public class EntityMenu extends DropDownMenu {
		
		/**
		 * Class constructor
		 */
		public function EntityMenu(parent:DisplayObjectContainer, permissions:Array) {
			super(parent, _("Entity"));
			
			/*
			   addItem({label: _("Create entity"), onClick: onCreateEntity});
			   addItem({label: _("Entity presets"), onClick: onEntityPresets});
			   addItem({label: _("Select entity"), onClick: onSelectEntity});
			   //addItem({label: "Add component", onClick: onAddComponent});
			   addItem( { label: _("Properties") } );
			 */
			
			var menuItems:Array = [{label: _("Create entity"), onClick: onCreateEntity}, {label: _("Entity presets"), onClick: onEntityPresets}, {label: _("Select entity"), onClick: onSelectEntity}, 
				//addItem({label: "Add component", onClick: onAddComponent});
				{label: _("Properties")}];
			
			if (permissions) {
				for (var i:int = 0; i < permissions.length; i++) {
					if (permissions[i] == "true") {
						if (menuItems[i]) {
							this.addItem(menuItems[i]);
						} else {
							Logger.log("dm.builder.interfaces.tools.MapMenu.MapMenu() : Trying to set permissions for non existing menu item at index: " + i, Logger.LEVEL_WARN);
						}
						
					}
					
				}
			} else {
				for each (var item:Object in menuItems) {
					this.addItem(item);
				}
			}
		
		}
		
		private function onEntityPresets():void {
			new Presets(null);
		}
		
		private function onSelectEntity():void {
			new SelectEntity(null);
		}
		
		private function onCreateEntity():void {
			new NewEntity(null);
		}

	}

}