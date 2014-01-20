package dm.builder.interfaces {
	
	import dm.game.windows.alert.Alert;
	import dm.game.windows.DmWindow;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.DataGrid;
	import fl.controls.SelectableList;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import net.richardlord.ash.signals.Signal1;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import ucc.project.data_finder.DataFinder;
	import ucc.project.dialog_editor.service.DialogEditorService;
	import ucc.ui.dataview.ColumnFactory;
	
	/**
	 * Edit condition window
	 * @version $Id: EditConditionWindow.as 123 2013-05-13 07:08:24Z rytis.alekna $
	 */
	public class EditCondition extends DmWindow {
		
		/** Available conditions */
		private static var availableOptions:Array;
		
		/** Params history */
		private static var paramsHistory:Dictionary = new Dictionary();
		
		/** Findable data definitions */
		private static var findableData:Object = {"hasItem_itemId": ["items", ["id", "label", "description"], "label", "id"], "noItem_itemId": ["items", ["id", "label", "description"], "label", "id"], "avatarRoleIs_roleId": ["avatar_roles", ["id", "label"], "label", "id"], "hasVar_label": ["avatar_vars_labels", ["label", "comment"], "label", "label"], "noVar_label": ["avatar_vars_labels", ["label", "comment"], "label", "label"], "varIs_label": ["avatar_vars_labels", ["label", "comment"], "label", "label"], "varMore_label": ["avatar_vars_labels", ["label", "comment"], "label", "label"], "varLess_label": ["avatar_vars_labels", ["label", "comment"], "label", "label"]};
		
		/** Option name combo box */
		public var optionNameComboBoxDO:ComboBox;
		
		/** Params list */
		public var paramsListDO:DataGrid;
		
		/** Save button */
		public var saveButtonDO:Button;
		
		/** Close button */
		public var closeWindowButtonDO:Button;
		
		/** Find data button */
		public var findDataButtonDO:Button;
		
		/** option */
		protected var condition:Object;
		
		/** conditionsListDO */
		protected var conditionsListDO:SelectableList;
		
		public var conditionSavedSignal:Signal1 = new Signal1(Object);
		
		/**
		 * Class constructor
		 */
		public function EditCondition(option:Object = null, conditionsListDO:SelectableList = null, parent:DisplayObjectContainer = null) {
			this.conditionsListDO = conditionsListDO;
			condition = option;
			super(parent, _("Edit condition"));
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			
			closeWindowButtonDO.addEventListener(MouseEvent.CLICK, onCloseButtonClick)
			
			paramsListDO.addColumn((new ColumnFactory("label")).setHeaderText(_("Param name")).setEditable(false).getColumn())
			
			paramsListDO.addColumn((new ColumnFactory("value")).setHeaderText(_("Value")).setEditable(true).setLabelFunction(trimValue).getColumn())
			
			if (!availableOptions) {
				DialogEditorService.getAllConditions().addResponders(onOptionsLabelsLoaded).call();
			} else {
				setUpDataView();
			}
		
		}
		
		/**
		 * Trim value
		 * @param	item
		 * @return
		 */
		protected function trimValue(item:Object):String {
			item.value = StringUtils.trimToEmpty(item.value);
			return item.value;
		}
		
		/**
		 * On conditions labels loaded
		 * @param	conditions
		 */
		protected function onOptionsLabelsLoaded(options:Array):void {
			availableOptions = options;
			setUpDataView();
		}
		
		/**
		 * Set up dat view
		 */
		protected function setUpDataView():void {
			
			saveButtonDO.addEventListener(MouseEvent.CLICK, onSaveButtonClick);
			closeWindowButtonDO.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			optionNameComboBoxDO.dataProvider = new DataProvider(availableOptions);
			
			if (condition) {
				paramsListDO.dataProvider = new DataProvider(condition.params);
				
				for each (var item:Object in availableOptions) {
					if (item.label == condition.label) {
						optionNameComboBoxDO.selectedItem = item;
						break;
					}
				}
				
			}
			
			optionNameComboBoxDO.addEventListener(Event.CHANGE, onOptionChange);
			onOptionChange(null);
			findDataButtonDO.addEventListener(MouseEvent.CLICK, onFindDataButtonClick);
			paramsListDO.addEventListener(ListEvent.ITEM_CLICK, onParamsListItemClick);
		
		}
		
		/**
		 *	On save button click
		 */
		protected function onSaveButtonClick(event:MouseEvent):void {
			
			var item:Object;
			
			for each (item in paramsListDO.dataProvider.toArray()) {
				if (!item.value || (StringUtils.trimToEmpty(item.value) == "")) {
					Alert.show(_("Parameters values can\'t be empty!"), _("Dialgo editor"));
					return;
				}
			}
			
			if (!condition) {
				condition = new Object();
				condition.params = new Array();
				conditionsListDO.addItem(condition);
			}
			
			if (condition.label != optionNameComboBoxDO.selectedItem.label) {
				
				condition.label = optionNameComboBoxDO.selectedItem.label;
				
				// clear all params
				condition.params.length = 0;
				
				for each (item in paramsListDO.dataProvider.toArray())
					condition.params.push({label: item.label, value: StringUtils.trimToEmpty(item.value)});
				
			}
			
			conditionSavedSignal.dispatch(condition);
			
			conditionsListDO.invalidateItem(condition);
			destroy();
		
		}
		
		/**
		 * On close button click
		 */
		protected function onCloseButtonClick(event:MouseEvent):void {
			destroy();
		}
		
		/**
		 *	On option change
		 */
		protected function onOptionChange(event:Event):void {
			
			if (condition && (optionNameComboBoxDO.selectedItem.label == condition.label)) {
				paramsListDO.dataProvider = new DataProvider(condition.params);
			} else {
				
				paramsListDO.dataProvider = new DataProvider();
				
				var conditionParam:Object;
				
				var conditionDef:Object;
				
				if (optionNameComboBoxDO.selectedItem) {
					conditionDef = optionNameComboBoxDO.selectedItem;
				} else {
					conditionDef = optionNameComboBoxDO.getItemAt(0);
				}
				
				for each (var item:Object in conditionDef.params) {
					conditionParam = {label: item.label};
					paramsListDO.addItem(item);
				}
				
			}
		
		}
		
		/**
		 *	On find data buton click
		 */
		protected function onFindDataButtonClick(event:MouseEvent):void {
			if (paramsListDO.selectedItem) {
				ClassUtils.newInstance(DataFinder, (findableData[optionNameComboBoxDO.selectedItem.label + "_" + paramsListDO.selectedItem.label] as Array).concat([setDataToParam]))
			} else {
				// this shouldn't happen
				trace("[ucc.project.dialog_editor.window.EditConditionWindow.onFindDataButtonClick()]");
			}
		
		}
		
		protected function setDataToParam(data:*):void {
			if (paramsListDO.selectedItem && findableData[optionNameComboBoxDO.selectedItem.label + "_" + paramsListDO.selectedItem.label]) {
				paramsListDO.selectedItem.value = data;
				paramsListDO.invalidateItem(paramsListDO.selectedItem);
			}
		}
		
		/**
		 *	On params list item click
		 */
		protected function onParamsListItemClick(event:ListEvent):void {
			if (findableData[optionNameComboBoxDO.selectedItem.label + "_" + event.item.label]) {
				findDataButtonDO.enabled = true;
				onFindDataButtonClick(null);
			} else {
				findDataButtonDO.enabled = false;
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function destroy():void {
			conditionSavedSignal.removeAll();
			saveButtonDO.removeEventListener(MouseEvent.CLICK, onSaveButtonClick);
			closeWindowButtonDO.removeEventListener(MouseEvent.CLICK, onCloseButtonClick);
			super.destroy();
		}
	
	}

}