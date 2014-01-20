package dm.builder.interfaces.map {
	
	import dm.builder.interfaces.dropdownmenu.DropDownMenu;
	import dm.game.managers.MapManager;
	import flash.display.DisplayObjectContainer;
	import ucc.logging.Logger;
	
	/**
	 * ...
	 * @author
	 */
	public class MapMenu extends DropDownMenu {
		
		public function MapMenu(parent:DisplayObjectContainer, permissions:Array) {
			super(parent, _("Map"));
			
			/*
			   addItem({label: _("New map"), onClick: newMap});
			   addItem({label: _("Load map"), onClick: loadMap});
			   addItem({label: _("Save map"), onClick: saveMap});
			   addItem({label: _("Save map as...)", onClick: saveMapAs});
			   addItem({label: _("Properties"), onClick: properties});
			   addItem({label: _("Room manager"), onClick: roomManager});
			   addItem({label: _("Try map"), onClick: tryMap});
			   addItem( { label: _("Add spawn point"), onClick: addSpawnPoint } );
			 */
			
			var menuItems:Array = [{label: _("New map"), onClick: newMap}, {label: _("Load map"), onClick: loadMap}, {label: _("Save map"), onClick: saveMap}, {label: _("Save map as..."), onClick: saveMapAs}, {label: _("Properties"), onClick: properties}, {label: _("Add spawn point"), onClick: addSpawnPoint}];
			
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
		
		private function addSpawnPoint():void {
			MapManager.instance.createAvatarSpawnPoint();
		}
		
		private function properties():void {
			new NewMap(this, true);
		}
		
		private function saveMapAs():void {
			new SaveMapAs(null);
		}
		
		private function loadMap():void {
			new SelectMap(null).mapSelectedSignal.add(onMapSelected);
			
			function onMapSelected(mapInfo:Object):void {
				MapManager.instance.loadMap(mapInfo.id);
			}
		}
		
		private function saveMap():void {
			MapManager.instance.saveMapAs(MapManager.instance.currentMap.label, 0);
		}
		
		public function newMap():void {
			var newMap:NewMap = new NewMap(null);
		}
	
	}

}