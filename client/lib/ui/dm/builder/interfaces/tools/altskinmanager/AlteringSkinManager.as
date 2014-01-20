package dm.builder.interfaces.tools.altskinmanager {
	
	import dm.builder.interfaces.components.SelectSkin3D;
	import dm.builder.interfaces.EditCondition;
	import dm.game.managers.MyManager;
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.DataGrid;
	import fl.controls.List;
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.as3commons.lang.StringUtils;
	import ucc.ui.dataview.ColumnFactory;
	import ucc.ui.dataview.DataViewBuilder;
	import ucc.ui.window.WindowsManager;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class AlteringSkinManager extends DmWindow {
		
		private const ALTSKIN_OBJECT_TYPE_ID:int = 7;
		
		public var altskin_dg:DataGrid;
		
		public var label_ti:TextInput;
		
		public var skin_list:List;
		public var condition_list:List;
		
		public var filterTextInputDO:TextInput;
		public var maskCheckBoxDO:CheckBox;
		
		public var category_cb:ComboBox;
		public var showAll_cb:CheckBox;
		
		public var categoryProperty_cb:ComboBox;
		
		public var newAltskin_btn:Button;
		
		public var addSkin_btn:Button;
		public var removeSkin_btn:Button;
		public var setDefault_btn:Button;
		
		public var addCondition_btn:Button;
		public var editCondition_btn:Button;
		public var removeCondition_btn:Button;
		
		public var save_btn:Button;
		
		private var dataViewBuilder:DataViewBuilder;
		
		public function AlteringSkinManager(parent:DisplayObjectContainer) {
			super(parent, _("Altering skin manager"));
		}
		
		public override function initialize():void {
			
			altskin_dg.addEventListener(ListEvent.ITEM_CLICK, onAltskinSelect);
			
			filterTextInputDO.addEventListener(Event.CHANGE, onFilterChange);
			maskCheckBoxDO.addEventListener(Event.CHANGE, onFilterChange);
			
			category_cb.addEventListener(Event.CHANGE, onFilterChange);
			showAll_cb.addEventListener(Event.CHANGE, onFilterChange);
			
			addSkin_btn.addEventListener(MouseEvent.CLICK, onAddSkinBtn);
			removeSkin_btn.addEventListener(MouseEvent.CLICK, onRemoveSkinBtn);
			setDefault_btn.addEventListener(MouseEvent.CLICK, onSetDefaultBtn);
			
			addCondition_btn.addEventListener(MouseEvent.CLICK, onAddConditionBtn);
			editCondition_btn.addEventListener(MouseEvent.CLICK, onEditConditionBtn);
			removeCondition_btn.addEventListener(MouseEvent.CLICK, onRemoveConditionBtn);
			
			save_btn.addEventListener(MouseEvent.CLICK, onSaveBtn);
			
			skin_list.addEventListener(ListEvent.ITEM_CLICK, onSkinListItemClick);
			skin_list.dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, onSkinListChange);
			skin_list.labelFunction = skinListLabelFunction;
			
			condition_list.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onEditConditionBtn);
			condition_list.dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, onConditionListChange);
			condition_list.labelFunction = conditionListDataFunction;
			
			newAltskin_btn.addEventListener(MouseEvent.CLICK, onNewAltskinBtn);
			
			AltskinManagerService.getAllCategories().addResponders(onCategories).call();
			dataViewBuilder = (new DataViewBuilder(altskin_dg)).addColumn((new ColumnFactory("id")).setHeaderText(_("Id")).setWidth(35).getColumn()).addColumn((new ColumnFactory("label")).setHeaderText(_("Name")).setWidth(220).getColumn()).addColumn((new ColumnFactory("last_modified")).setHeaderText(_("Last modified")).setWidth(115).getColumn()).addColumn((new ColumnFactory("last_modified_by")).setHeaderText(_("Modified by")).setWidth(78).getColumn()).setService(AltskinManagerService.getUserAltskins(MyManager.instance.id)).refresh();
			
			turnSkinControls(false);
			turnConditionControls(false);
		}
		
		private function onCategories(response:Object):void {
			for each (var category:Object in response)
				if (category.object_type_id == ALTSKIN_OBJECT_TYPE_ID) {
					category_cb.addItem(category);
					categoryProperty_cb.addItem(category);
				}
		}
		
		private function onConditionListChange(e:DataChangeEvent):void {
			if (skin_list.selectedItem)
				skin_list.selectedItem.conditions = condition_list.dataProvider.toArray();
		}
		
		private function onSkinListChange(e:DataChangeEvent):void {
			if (altskin_dg.selectedItem)
				altskin_dg.selectedItem.skins3d = skin_list.dataProvider.toArray();
		}
		
		private function onAltskinSelect(e:ListEvent):void {
			label_ti.text = e.item.label;
			turnSkinControls(true);
			skin_list.removeAll();
			condition_list.removeAll();
			
			for each (var category:Object in categoryProperty_cb)
				if (category.id == e.item.category_id) {
					categoryProperty_cb.selectedItem = category;
					break;
				}
			
			if (e.item.id)
				AltskinManagerService.getAltskinById(e.item.id).addResponders(onAltskinData).call();
		}
		
		private function onAltskinData(response:Object):void {
			if (response.skins3d)
				skin_list.dataProvider.addItems(response.skins3d);
		}
		
		private function onSkinListItemClick(e:ListEvent):void {
			if (e.item.is_default == 1) {
				turnConditionControls(false);
				condition_list.removeAll();
				return;
			} else
				turnConditionControls(true);
			
			condition_list.removeAll();
			if (e.item.conditions)
				condition_list.dataProvider = new DataProvider(e.item.conditions);
		}
		
		private function turnSkinControls(on:Boolean):void {
			skin_list.enabled = on;
			addSkin_btn.enabled = on;
			removeSkin_btn.enabled = on;
			setDefault_btn.enabled = on;
		}
		
		private function turnConditionControls(on:Boolean):void {
			condition_list.enabled = on;
			addCondition_btn.enabled = on;
			editCondition_btn.enabled = on;
			removeCondition_btn.enabled = on;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (label_ti.text == "") {
				Alert.show("Enter label.");
				stage.focus = label_ti;
				return;
			}
			
			var is_defaultSkinIsSet:Boolean = false;
			for (var i:int = 0; i < skin_list.length; i++)
				if (skin_list.dataProvider.getItemAt(i).is_default == 1) {
					is_defaultSkinIsSet = true;
					break;
				}
			
			if (!is_defaultSkinIsSet) {
				Alert.show("Set default skin.");
				return;
			}
			
			altskin_dg.selectedItem.label = label_ti.text;
			altskin_dg.selectedItem.category_id = categoryProperty_cb.selectedItem.id;
			altskin_dg.selectedItem.skins3d = skin_list.dataProvider.toArray();
			
			//trace(JSON.stringify(altskin_dg.selectedItem));
			AltskinManagerService.saveAltskin(altskin_dg.selectedItem, MyManager.instance.id).addResponders(onAltskinSave).call();
		}
		
		private function onAltskinSave(result:Object):void {
			trace(result);
			dataViewBuilder.refresh();
		}
		
		private function onAddSkinBtn(e:MouseEvent):void {
			SelectSkin3D(WindowsManager.getInstance().createWindow(SelectSkin3D)).skin3dSelectedSignal.add(onSkinSelected);
		}
		
		private function onRemoveSkinBtn(e:MouseEvent):void {
			skin_list.removeItem(skin_list.selectedItem);
		}
		
		private function onSetDefaultBtn(e:MouseEvent):void {
			for (var i:int = 0; i < skin_list.length; i++)
				skin_list.dataProvider.getItemAt(i).is_default = 0;
			skin_list.selectedItem.is_default = 1;
			delete skin_list.selectedItem.conditions;
			skin_list.invalidateList();
		}
		
		private function skinListLabelFunction(skinData:Object):String {
			return (skinData.is_default == 1) ? skinData.label + " (default)" : skinData.label;
		}
		
		private function onSkinSelected(skinData:Object):void {
			skinData.is_default = int(skin_list.length == 0);
			skin_list.addItem(skinData);
		}
		
		private function onRemoveConditionBtn(e:MouseEvent):void {
			condition_list.removeItem(condition_list.selectedItem);
			skin_list.selectedItem.conditions = condition_list.dataProvider.toArray();
		}
		
		protected function onAddConditionBtn(e:MouseEvent):void {
			new EditCondition(null, this.condition_list).conditionSavedSignal.add(onConditionSaved);
		}
		
		protected function onEditConditionBtn(e:Event):void {
			new EditCondition(condition_list.selectedItem, condition_list).conditionSavedSignal.add(onConditionSaved);
		}
		
		private function onConditionSaved(condition:Object):void {
			skin_list.selectedItem.conditions = condition_list.dataProvider.toArray();
		}
		
		private static function conditionListDataFunction(conditionData:Object):String {
			var retVal:String = conditionData.label + " ( ";
			var param:Object;
			for (var i:int = 0; i < conditionData.params.length; i++) {
				param = conditionData.params[i];
				retVal += param.label + " : " + param.value;
				if (i < conditionData.params.length - 1)
					retVal += ", ";
			}
			retVal += " )";
			return retVal;
		}
		
		private function onNewAltskinBtn(e:MouseEvent):void {
			altskin_dg.addItemAt({label: "New altskin"}, 0);
			altskin_dg.selectedIndex = 0;
		}
		
		protected function onFilterChange(event:Event):void {
			
			var filter:Object = {};
			
			filter.__plain__label = StringUtils.trimToEmpty(label_ti.text);
			
			if (!showAll_cb.selected)
				filter.category_id = category_cb.selectedItem.id;
			
			dataViewBuilder.filterListByEquality(filter);		
		}
	
	}

}