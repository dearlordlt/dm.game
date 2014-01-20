package dm.builder.interfaces.tools.npceditor {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.builder.interfaces.WindowManager;
	import dm.game.managers.MyManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.richardlord.ash.signals.Signal0;
	import org.as3commons.lang.ObjectUtils;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class NpcProperties extends BuilderWindow {
		
		private var _npcId:int;
		private var cmd_list:List;
		private var label_ti:InputText;
		private var remove_btn:PushButton;
		private var edit_btn:PushButton;
		public var category_cb:ComboBox;
		
		public var npcSavedSignal:Signal0 = new Signal0();
		
		public function NpcProperties(parent:DisplayObjectContainer) {
			super(parent, "NPC", 210, 200);
		}
		
		override protected function createGUI():void {
			var label_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "Label: ");
			label_ti = new InputText(_body, label_lbl.x + label_lbl.textWidth + 5, label_lbl.y);
			
			var category_lbl:BuilderLabel = new BuilderLabel(_body, label_lbl.x, label_lbl.y + 25, _("Category") + ": ");
			category_lbl.width = category_lbl.textWidth;
			category_lbl.textAlign = "right";
			category_cb = new ComboBox(_body, category_lbl.x + category_lbl.textWidth + 5, category_lbl.y);
			
			label_lbl.width = category_lbl.width;
			label_lbl.textAlign = "right";
			label_ti.x = category_cb.x;
			
			var cmds_label:BuilderLabel = new BuilderLabel(_body, category_lbl.x + 20, category_lbl.y + 25, _("NPC commands") + ": ");
			cmd_list = new List(_body, cmds_label.x, cmds_label.y + 20);
			cmd_list.addEventListener(Event.SELECT, onCmdSelect);
			cmd_list.height -= 15;
			
			var up_btn:PushButton = new PushButton(_body, label_lbl.x - 5, cmd_list.y, ">", onUpBtn);
			up_btn.width = 20;
			up_btn.rotation = -90;
			up_btn.y += 40;
			var down_btn:PushButton = new PushButton(_body, up_btn.x, cmd_list.y, ">", onDownBtn);
			down_btn.width = up_btn.width;
			down_btn.rotation = 90;
			down_btn.x += down_btn.height;
			down_btn.y += 40;
			
			var add_btn:PushButton = new PushButton(_body, cmd_list.x + cmd_list.width + 5, cmd_list.y, _("Add"), onAddBtn);
			add_btn.width -= 35;
			
			remove_btn = new PushButton(_body, add_btn.x, add_btn.y + 30, _("Remove"), onRemoveBtn);
			remove_btn.width = add_btn.width;
			remove_btn.enabled = false;
			
			edit_btn = new PushButton(_body, remove_btn.x, remove_btn.y + 30, _("Edit"), onEditBtn);
			edit_btn.width = remove_btn.width;
			edit_btn.enabled = false;
			
			var save_btn:PushButton = new PushButton(_body, _width * 0.5, cmd_list.y + cmd_list.height + 10, _("Save"), onSaveBtn);
			save_btn.x -= save_btn.width * 0.5;
		}
		
		private function onCmdSelect(e:Event):void {
			remove_btn.enabled = true;
			edit_btn.enabled = true;
		}
		
		private function onSaveBtn(e:MouseEvent):void {
			if (label_ti.text != "") {
				var npc:Object = {id: _npcId, label: label_ti.text, category_id: category_cb.selectedItem.id, commands: cmd_list.items, authorId: MyManager.instance.id};
				var amfphp:AMFPHP = new AMFPHP(onNpcSaved);
				amfphp.xcall("dm.NPC.saveNpc", npc, MyManager.instance.id);
			}
			
			function onNpcSaved(response:Object):void {
				npcSavedSignal.dispatch();
				WindowManager.instance.dispatchMessage("NPC saved.");
			}
		}
		
		private function onUpBtn(e:MouseEvent):void {
			if (cmd_list.selectedIndex > 0) {
				var temp:Object = cmd_list.items[cmd_list.selectedIndex];
				cmd_list.items[cmd_list.selectedIndex] = cmd_list.items[cmd_list.selectedIndex - 1];
				cmd_list.items[cmd_list.selectedIndex - 1] = temp;
				cmd_list.draw();
				cmd_list.selectedIndex--;
			}
		}
		
		private function onDownBtn(e:MouseEvent):void {
			if (cmd_list.selectedIndex < cmd_list.items.length - 1) {
				var temp:Object = cmd_list.items[cmd_list.selectedIndex];
				cmd_list.items[cmd_list.selectedIndex] = cmd_list.items[cmd_list.selectedIndex + 1];
				cmd_list.items[cmd_list.selectedIndex + 1] = temp;
				cmd_list.draw();
				cmd_list.selectedIndex++;
			}
		}
		
		private function onAddBtn(e:MouseEvent):void {
			var newCommand:CommandProperties = new CommandProperties(parent.parent);
			newCommand.commandAddedSignal.add(onCommandAdded);
		}
		
		private function onCommandAdded(command:Object):void {
			cmd_list.addItem(command);
		}
		
		private function onRemoveBtn(e:MouseEvent):void {
			cmd_list.removeItemAt(cmd_list.selectedIndex);
		}
		
		private function onEditBtn(e:MouseEvent):void {
			var commandProperties:CommandProperties = new CommandProperties(parent, ObjectUtils.clone(cmd_list.selectedItem));
			commandProperties.commandAddedSignal.add(onCommandEdit);
		}
		
		private function onCommandEdit(command:Object):void {
			var currentIndex:int = cmd_list.selectedIndex;
			cmd_list.removeItemAt(currentIndex);
			cmd_list.addItemAt(command, currentIndex);
		}
		
		public function clearData():void {
			_npcId = 0;
			label_ti.text = "NewNpc";
			category_cb.selectedIndex = 0;
			cmd_list.items = [];
		}
		
		public function set data(npcData:Object):void {
			_npcId = npcData.id;
			label_ti.text = npcData.label;
			
			for each (var item:Object in category_cb.items)
				if (item.id == npcData.category_id)
					category_cb.selectedItem = item;
			
			cmd_list.items = npcData.commands;
		}
	}

}