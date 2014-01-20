package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.events.*; 
	import flash.display.Shape;
	 
	public class NodePopup extends Sprite  
	{
		
		public var _addchildnodebtn:AddChildNodeBtn = new AddChildNodeBtn;
		public var _deletenodebtn:DeleteNodeBtn= new DeleteNodeBtn;
		public var _editnodebtn:EditNodeBtn = new EditNodeBtn;
		public var current_node:Object = new Object;
		private var holder:*;
		public var _node_editor:Object;
		public var mini_preview:Object;
		
		public function NodePopup() {
			this.addEventListener(Event.ADDED, thisWasAdded);	
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			_node_editor = holder.getChildByName("NodeEditor");
			mini_preview = holder.getChildByName("mini_preview");	
			
			var triangleHeight:uint = 15;
			var triangleShape:Shape = new Shape();
			triangleShape.graphics.beginFill(0xFFFFFF);
			triangleShape.graphics.moveTo(triangleHeight/2, 5);
			triangleShape.graphics.lineTo(triangleHeight, triangleHeight+5);
			triangleShape.graphics.lineTo(0, triangleHeight+5);
			triangleShape.graphics.lineTo(triangleHeight/2, 5);
			this.addChild(triangleShape);
			triangleShape.rotation = -45;
			triangleShape.x = -13;
			triangleShape.y = -13;
			var popup_back_holder:Sprite = new Sprite;
			this.addChild(popup_back_holder);
			drawRoundRect(popup_back_holder, 150, 135, 10, 10, 10, 10, 0, 0x000000, 0xFFFFFF, 0.9);
			popup_back_holder.x = 10;
			popup_back_holder.y = 0;
			popup_back_holder.addChild(_addchildnodebtn);
			_addchildnodebtn.addEventListener(MouseEvent.CLICK, onClickAddChildBtn);
			_addchildnodebtn.x = 150 / 2;
			_addchildnodebtn.y = 25;
			popup_back_holder.addChild(_editnodebtn);
			_editnodebtn.addEventListener(MouseEvent.CLICK, onClickEditBtn);
			_editnodebtn.x = 150 / 2;
			_editnodebtn.y = _addchildnodebtn.y + _addchildnodebtn.height + 5;
			popup_back_holder.addChild(_deletenodebtn);
			_deletenodebtn.addEventListener(MouseEvent.CLICK, onClickDeleteBtn);
			_deletenodebtn.x = 150 / 2;
			_deletenodebtn.y = _editnodebtn.y + _editnodebtn.height + 5;
		}
			
		private function onClickAddChildBtn(event:MouseEvent):void {
			this.visible = false;
			mini_preview.hideMiniPreview();
			_node_editor.ShowNodeEditor(current_node, "add");
			_node_editor.updateNodeEditorPosition(holder.size.width, holder.size.height);
		}
		
		private function onClickEditBtn(event:MouseEvent):void{
			this.visible = false;
			mini_preview.hideMiniPreview();
			_node_editor.ShowNodeEditor(current_node, "edit");
			_node_editor.updateNodeEditorPosition(holder.size.width, holder.size.height);
		}
		
		private function onClickDeleteBtn(event:MouseEvent):void {
			this.visible = false;
			mini_preview.hideMiniPreview();
			_node_editor.ShowNodeEditor(current_node, "delete");
			_node_editor.updateNodeEditorPosition(holder.size.width, holder.size.height);
		}
	
		public function activateNodePopup(node:Object):void {
			this.current_node = node;
			
			//trace(current_node.info.id);
		}
		
		private  function drawRoundRect(spr:Sprite, w:Number , h:Number, tl:Number, tr:Number, bl:Number, br:Number, thick:Number, borderColor:Number, bgColor:Number, trans:Number ):void {
			if (thick != 0) spr.graphics.lineStyle(thick, borderColor);
			spr.graphics.beginFill(bgColor, trans);
			spr.graphics.moveTo( 0, tl );
			spr.graphics.curveTo( 0, 0, tl, 0 );
			spr.graphics.lineTo(w - tr, 0);
			spr.graphics.curveTo( w, 0, w, tr );
			spr.graphics.lineTo(w, h - br);
			spr.graphics.curveTo( w, h, w - br, h );
			spr.graphics.lineTo(bl, h);
			spr.graphics.curveTo( 0, h, 0, h - bl );
			spr.graphics.endFill();
		}	
		
	}

}