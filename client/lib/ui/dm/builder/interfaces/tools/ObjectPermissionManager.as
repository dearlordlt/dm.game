package dm.builder.interfaces.tools {
	
	import dm.game.managers.MyManager;
	import dm.game.windows.DmWindow;
	import fl.controls.ComboBox;
	import fl.controls.DataGrid;
	import fl.controls.TextInput;
	import fl.controls.CheckBox;
	import fl.controls.Button;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ucc.data.service.Service;
	import ucc.project.dialog_editor.service.DialogEditorService;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.util.Delegate;
	import utils.AMFPHP;
	
	/**
	 * Right manager window
	 * @version $Id: RightsManagerWindow.as 64 2013-03-11 12:23:32Z rytis.alekna $
	 */
	public class ObjectPermissionManager extends DmWindow {
		
		/** Dialogs list */
		public var objectListDO:DataGrid;
		
		public var objectTypeComboBoxDO:ComboBox;
		
		/** Dialogs filter text input */
		public var objectFilterTextInputDO:TextInput;
		
		/** Dialogs filter use reg exp check box */
		public var objectFilterUseRegExpCheckBoxDO:CheckBox;
		
		/** Assigned users list */
		public var assignedUsersListDO:DataGrid;
		
		/** Assigned users filter text input */
		public var assignedUsersFilterTextInputDO:TextInput;
		
		/** Assigned users filter use reg exp check box */
		public var assignedUsersFilterUseRegExpCheckBoxDO:CheckBox;
		
		/** All users list */
		public var allUsersListDO:DataGrid;
		
		/** All users filter text input */
		public var allUsersFilterTextInputDO:TextInput;
		
		/** All users filter use reg exp check box */
		public var allUsersFilterUseRegExpCheckBoxDO:CheckBox;
		
		/** Add user button */
		public var addUserButtonDO:Button;
		
		/** Add user button */
		public var removeUserButtonDO:Button;
		
		/** Dialog list data view builder */
		protected var objectListDataBuilder:DataViewBuilder;
		
		/** Assigned users list data builder */
		protected var assignedUsersListDataBuilder:DataViewBuilder;
		
		/** All users list data builder */
		protected var allUsersListDataBuilder:DataViewBuilder;
		
		private var _userObjects:Array;
		
		/**
		 * Rights manager window
		 */
		public function ObjectPermissionManager(parent:DisplayObjectContainer = null) {
			super(parent, _("Object permission manager"));
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			
			var amfphp:AMFPHP;
			
			amfphp = new AMFPHP(onObjectTypes).xcall("dm.ObjectPermissions.getObjectTypes");
			function onObjectTypes(response:Object):void {
				objectTypeComboBoxDO.dataProvider = new DataProvider(response);
			}
			
			amfphp = new AMFPHP(onUserObjects).xcall("dm.ObjectPermissions.getUserObjects", MyManager.instance.id);
			function onUserObjects(response:Object):void {
				_userObjects = response as Array;
				refreshObjectList(null);
			}
			
			this.objectListDataBuilder = (new DataViewBuilder(this.objectListDO)).addColumn((new ColumnFactory("id")).setHeaderText(_("Id")).setWidth(40).getColumn()).addColumn((new ColumnFactory("label")).setHeaderText(_("Label")).getColumn()).addColumn((new ColumnFactory("last_modified")).setHeaderText(_("Last modified")).getColumn()).addColumn((new ColumnFactory("last_modified_by")).setHeaderText(_("Modified by")).getColumn())
			
			this.assignedUsersListDataBuilder = (new DataViewBuilder(this.assignedUsersListDO)).createColumn("id", _("Id"), 40).createColumn("username", _("Username"))
			
			this.allUsersListDataBuilder = (new DataViewBuilder(this.allUsersListDO)).createColumn("id", _("Id"), 40).createColumn("username", _("Username")).setService(DialogEditorService.getAllUsers()).refresh()
			
			objectTypeComboBoxDO.addEventListener(Event.CHANGE, refreshObjectList);
			
			this.objectListDO.addEventListener(ListEvent.ITEM_CLICK, this.onObjectListItemClick);
			
			this.allUsersListDO.addEventListener(ListEvent.ITEM_CLICK, this.onAllUsersListItemClick);
			this.assignedUsersListDO.addEventListener(ListEvent.ITEM_CLICK, this.onAssignedUsersListItemClick);
			
			this.addUserButtonDO.addEventListener(MouseEvent.CLICK, this.addUserToObject);
			this.removeUserButtonDO.addEventListener(MouseEvent.CLICK, this.removeUserFromDialog);
			
			this.objectFilterTextInputDO.addEventListener(Event.CHANGE, Delegate.createWithCallArgsIgnore(this.filterList, "name", this.objectListDataBuilder, this.objectFilterTextInputDO, this.objectFilterUseRegExpCheckBoxDO));
			this.assignedUsersFilterTextInputDO.addEventListener(Event.CHANGE, Delegate.createWithCallArgsIgnore(this.filterList, "username", this.assignedUsersListDataBuilder, this.assignedUsersFilterTextInputDO, this.assignedUsersFilterUseRegExpCheckBoxDO));
			this.allUsersFilterTextInputDO.addEventListener(Event.CHANGE, Delegate.createWithCallArgsIgnore(this.filterList, "username", this.allUsersListDataBuilder, this.allUsersFilterTextInputDO, this.allUsersFilterUseRegExpCheckBoxDO));
		}
		
		private function refreshObjectList(e:Event):void {
			objectListDO.removeAll();
			var amfphp:AMFPHP;
			switch (objectTypeComboBoxDO.selectedLabel) {
				case "NPC": 
					amfphp = new AMFPHP(onObjects).xcall("dm.NPC.getUserNpcs", MyManager.instance.id);
					break;
				case "loot": 
					amfphp = new AMFPHP(onObjects).xcall("dm.Loot.getUserLoot", MyManager.instance.id);
					break;
				case "item": 
					amfphp = new AMFPHP(onObjects).xcall("dm.Item.getUserItems", MyManager.instance.id);
					break;
				case "interaction": 
					amfphp = new AMFPHP(onObjects).xcall("dm.Interaction.getUserInteractions", MyManager.instance.id);
					break;
				case "map":
					amfphp = new AMFPHP(onObjects).xcall("dm.Maps.getUserMaps", MyManager.instance.id);
					break;
			}
			
			function onObjects(response:Object):void {
				objectListDO.dataProvider = new DataProvider(response);
			}
		
		}
		
		/**
		 *	On dialog list item click
		 */
		protected function onObjectListItemClick(e:ListEvent):void {
			objectListDO.selectedItem = e.item;
			refreshAssignedUsersList();
		}
		
		private function refreshAssignedUsersList():void {
			var amfphp:AMFPHP = new AMFPHP(onAssignedUsers).xcall("dm.ObjectPermissions.getObjectModerators", objectListDO.selectedItem.id, objectTypeComboBoxDO.selectedLabel);
			function onAssignedUsers(response:Object):void {
				assignedUsersListDO.dataProvider = new DataProvider(response);
			}
		}
		
		/**
		 *	On all user list item click
		 */
		protected function onAllUsersListItemClick(event:ListEvent):void {
			this.addUserButtonDO.enabled = true;
		}
		
		/**
		 *	On assigned user list item click
		 */
		protected function onAssignedUsersListItemClick(event:ListEvent):void {
			this.removeUserButtonDO.enabled = true;
		}
		
		/**
		 * Assign user to dialog
		 */
		protected function addUserToObject(event:Event):void {
			var amfphp:AMFPHP = new AMFPHP(refreshAssignedUsersList).xcall("dm.ObjectPermissions.addModeratorToObject", allUsersListDO.selectedItem.id, objectTypeComboBoxDO.selectedLabel, objectListDO.selectedItem.id);
		}
		
		/**
		 * Remove user from dialog
		 */
		protected function removeUserFromDialog(event:Object):void {
			var amfphp:AMFPHP = new AMFPHP(refreshAssignedUsersList).xcall("dm.ObjectPermissions.removeModeratorFromObject", assignedUsersListDO.selectedItem.id, objectTypeComboBoxDO.selectedLabel, objectListDO.selectedItem.id);
		}
		
		/**
		 * Filter list
		 */
		protected function filterList(dataField:String, dataViewBuilder:DataViewBuilder, textInputDO:TextInput, regExpCheckBoxDO:CheckBox):void {
			dataViewBuilder.filterListByString(dataField, textInputDO.text, regExpCheckBoxDO.selected);
		}
	
	}

}