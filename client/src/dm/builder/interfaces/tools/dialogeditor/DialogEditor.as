package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.Shape;
	
	public class DialogEditor extends Sprite 
	{
		public var root_holder:*;
		public var current_dialog_id:Number;
		public var current_user_id:Number;
		public var current_user_username:String;
		public var current_user_is_admin:String;
		public var root_holder_is_stage:Boolean = false;
		public var main_grid:MainGrid;
		public var nodes_holder:Object;
		public var size:Sprite;
		public var showing_area:Sprite;
		public var dialogs:DialogsControl;
		public var mini_preview:PhraseMiniPreview;
		public var zoom_c:ZoomControl;
		public var db:DataBase;
		public var n_popup:NodePopup;
		public var loading_anim:LoadingAnimation;
		public var node_editor:NodeEditor;
		public var gateway:String;
		public var _main_close_btn:MainCloseBtn;

		public function DialogEditor(user_id:Number,gateway:String) {
			this.current_user_id = user_id;
			this.gateway = gateway;
			this.addEventListener(Event.ADDED, thisWasAdded);
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			root_holder = stage;
			db = new DataBase(gateway);
			var params:Object = {"user_id":current_user_id}
			db.getUserById(getUserByIdResult,params)
		}
		
		public function getUserByIdResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr2");
			}else {
				
			root_holder.addEventListener(Event.RESIZE, onRootHolderResize);
			if(this.stage){
				root_holder_is_stage = true;
			}

			current_user_username = r.username;
			current_user_is_admin = r.isadmin;
			
			main_grid = new MainGrid();
			this.addChild(main_grid);
			
			size = new Sprite;
			size.graphics.beginFill(0xFF0000);
			size.graphics.drawRect(0, 0, 1,1);
			size.graphics.endFill();
			root_holder.addChild(size);
			update_size();
			this.mask = size;
			MoveGridToCenter();
			
			nodes_holder = main_grid.getChildByName("nodes_holder");
			mini_preview = new PhraseMiniPreview;
			mini_preview.name = "mini_preview";
			this.addChild(mini_preview);
			updateMiniPreviewPosition();
			
			dialogs = new DialogsControl;
			dialogs.name = "DialogsControl";
			this.addChild(dialogs);
			
			loading_anim = new LoadingAnimation(0.8, 0xffffff, 0x333333);
			loading_anim.name = "loading_animation";
			this.addChild(loading_anim);
			
			node_editor = new NodeEditor;
			this.addChild(node_editor);
			node_editor.name = "NodeEditor";
			
			n_popup = new NodePopup;
			this.addChild(n_popup);
			n_popup.name = "NodePopup";
			n_popup.visible = false;
			
			_main_close_btn = new MainCloseBtn;
			this.addChild(_main_close_btn);
			_main_close_btn.addEventListener(MouseEvent.CLICK, mainCloseBtnClick);
			updateCloseBtnPosition();
			
			zoom_c = new ZoomControl(main_grid);
			this.addChild(zoom_c);
			
			updateZoomControlPosition();

			this.setChildIndex(node_editor, this.numChildren - 1);
			if (node_editor.is_active == true) {
				node_editor.updateNodeEditorPosition(size.width, size.height);
			}
			this.setChildIndex(loading_anim, this.numChildren-1); 	
			}
		}
		

		
		private function mainCloseBtnClick(event:MouseEvent):void {
			/*while (this.numChildren > 0) {
				this.removeChildAt(0);
			}*/
			parent.removeChild(this);
		}
		
		public function updateCloseBtnPosition():void {
			_main_close_btn.x = size.width - _main_close_btn.width + 20;
			_main_close_btn.y = 45;
		}
		
		
		public function updateZoomControlPosition():void {
			zoom_c.x = size.width - zoom_c.width +20;
			zoom_c.y = size.height - 40;
		}
		
		public function updateMiniPreviewPosition():void {
			mini_preview.x = size.width/2 - mini_preview.width/2;
			mini_preview.y = 20;
		}
		

		/*public function updateNodePopupPosition():void {
			n_popup.x = size.width - n_popup.width - 10;
			n_popup.y = size.height - n_popup.height - 10;
		}*/
		
		
		public function loadDialogNodes(dialog_id:Number=-1):void {
			if (dialog_id == -1) {
				cleanNodesHolder();
			}else{
				loading_anim.showLoadinAnimation(size.width, size.height);
				db.getDialog(loadDialogNodesResult, dialog_id);
			}
		}
		
		public function cleanNodesHolder():void {		
			while (nodes_holder.numChildren > 0) {
				nodes_holder.removeChildAt(0);
			}
		}
		
		public function loadDialogNodesResult(r:Object): void {
			if (r == false) {
				trace("Error reading records. Nr3");
			}else {
				n_popup.visible = false;
				cleanNodesHolder();
				var r2:Object = r;
				for (var index:String in r) {
					
					var node:Node = new Node(r[index]);
					if (r[index].type == "dialog") {
						node.name = "nodedialog_" + r[index].id;
					}else {
						node.name = "node_" + r[index].id;
					}
					node.buttonMode = true;
					nodes_holder.addChild(node);
					
					var node_text:NodeText = new NodeText(node);
					nodes_holder.addChild(node_text);
					
					
				}
				if (r.length == 1) {
					var node0:Sprite = nodes_holder.getChildByName("nodedialog_" +  r[0].id);
					var relation0:RelationLine = new RelationLine(node0, node0);
					nodes_holder.addChild(relation0);
				}else{
					for (var a:int = 0; a < r.length; a++) {
						for (var b:int = a; b < r.length; b++) {
							if (a != b) {
								if (r[a].id == r[b].parent_id || r[b].id == r[a].parent_id || (r[a].type == "dialog" && r[b].parent_id == "0")) {
									var name_pref:String = "node_";
									if (r[a].type == "dialog") {
										name_pref = "nodedialog_";
									}
									var node1:Sprite = nodes_holder.getChildByName(name_pref +  r[a].id);
									var node2:Sprite = nodes_holder.getChildByName("node_" +  r[b].id);
									if (r[a].id == r[b].parent_id || (r[a].type == "dialog" && r[b].parent_id == "0")) {
										var relation1:RelationLine = new RelationLine(node1, node2);
										nodes_holder.addChild(relation1);
									}else {
										var relation2:RelationLine = new RelationLine(node2, node1);
										nodes_holder.addChild(relation2);
									}
								}
							}
						}
					}
				}
			}
			loading_anim.hideLoadinAnimation();
			dialogs.refreshDialogList();
		}
		
		
		
		
		public function update_size():void {
			size.width = root_holder_is_stage ? root_holder.stageWidth : root_holder.width;
			size.height = root_holder_is_stage ? root_holder.stageHeight : root_holder.height;
		}
		
		/*private function onMouseDownCircle(event:MouseEvent):void {
			nodes_holder.parent.grid_area_is_clicked = false;
		}*/
		
		private function onRootHolderResize(e:Event):void {
			n_popup.visible = false;
			main_grid.scaleX = 1;
			main_grid.scaleY = 1;
			update_size();
			MoveGridToCenter();
			dialogs.updateDialogsControlSize();
			updateCloseBtnPosition();
			updateZoomControlPosition();
			updateMiniPreviewPosition();
			if (loading_anim.is_active == true) {
				loading_anim.showLoadinAnimation(size.width, size.height);
			}
			if (node_editor.is_active == true) {
				node_editor.updateNodeEditorPosition(size.width, size.height);
			}
			
			//updateNodePopupPosition();
		}
		
		public function MoveGridToCenter():void{
			main_grid.x = size.width / 2 - main_grid.width / 2;
			main_grid.y = size.height / 2 - main_grid.height / 2;
		}
		
	}
}