package dm.builder.interfaces.tools.dialogeditor  
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	import flash.display.Sprite;
	import flash.events.*; 
	import flash.events.MouseEvent;
	 
	public class TabsControl extends Sprite  
	{
		public var tabs_counter:Number = 0;
		public var tab_width:Number = 70;
		public var tab_content_width:Number = 460;
		public var tab_content_height:Number = 455;
		public var tab_content_x:Number = 100;
		public var tab_content_y:Number = 20;
		private var holder:*;
		
		public function TabsControl() {
				this.addEventListener(Event.ADDED, thisWasAdded);
		}
		
		private function thisWasAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, thisWasAdded);
			holder = this.parent;
			
		}
		
		public function addTab(icon:Sprite,cnt:Sprite):void {
			tabs_counter++; 
			var tab_holder:Sprite = new Sprite;
			tab_holder.name = 'tab_holder_' + tabs_counter;
			this.addChild(tab_holder);
			var tab_area:Sprite = new Sprite;
			//tab_area.mouseEnabled = false;
			tab_area.name = 'tab_area';
			drawTabArea(tab_area, tabs_counter, 0x89AFC2, 0x5A7582);
			tab_holder.addChild(tab_area);
			var tab_area_active:Sprite = new Sprite;
			tab_area_active.mouseEnabled = false;
			tab_area_active.name = 'tab_area_active';
			drawTabArea(tab_area_active, tabs_counter, 0x5A7582, 0xFFFFFF);
			tab_holder.addChild(tab_area_active);
			this.setChildIndex(tab_holder, 0); 
			var icon_holder:Sprite = new Sprite;
			icon_holder.name = 'icon_holder';
			tab_holder.addChild(icon_holder);
			icon_holder.addChild(icon);
			icon_holder.mouseEnabled = false;
			icon_holder.mouseChildren = false;
			tab_area.addEventListener(MouseEvent.CLICK, tabClick); 
			if (tabs_counter > 1) {
				updateTabs();
				tab_area_active.visible = false;
			}
			var tab_content_holder:Sprite = new Sprite;
			tab_content_holder.name = 'tab_content_holder';
			tab_holder.addChild(tab_content_holder);
			tab_content_holder.x = tab_content_x;
			tab_content_holder.y = tab_content_y;
			tab_content_holder.addChild(cnt);
		}
		
		private function tabClick(event:MouseEvent):void {
			var par_obj:Object = event.target.parent;
			var obj_name:String = par_obj.name;
			var obj:Object = this.getChildByName(obj_name);
			this.setChildIndex(obj as Sprite, this.numChildren - 1);
			var tab_area_active:Object = obj.getChildByName("tab_area_active");
			makeTabsDefault();
			tab_area_active.visible = true;
		}
		
		
		public function makeTabsDefault():void {
			var i:int; 
			for (i = 1; i <= tabs_counter; i++) { 
				var tab_holder:Object  = this.getChildByName("tab_holder_" + i);
				var tab_area_active:Object = tab_holder.getChildByName("tab_area_active");
				tab_area_active.visible = false;
			}
		}
		
		
		public function activateTab(tab_number:Number):void {
			var obj_name:String = "tab_holder_" + tab_number;
			var obj:Object = this.getChildByName(obj_name);
			this.setChildIndex(obj as Sprite, this.numChildren - 1);
			var tab_area_active:Object = obj.getChildByName("tab_area_active");
			makeTabsDefault();
			tab_area_active.visible = true;
		}
		
		
		
		public function updateTabs():void {
			var i:int; 
			for (i = 1; i <= tabs_counter; i++) { 
				var tab_holder:Object  = this.getChildByName("tab_holder_" + i);
				var tab_area:Object = tab_holder.getChildByName("tab_area");
				drawTabArea(tab_area, i, 0x89AFC2, 0x5A7582);
				var tab_area_active:Object = tab_holder.getChildByName("tab_area_active");
				drawTabArea(tab_area_active, i, 0x5A7582, 0xFFFFFF);
				var icon_holder:Object = tab_holder.getChildByName("icon_holder");
				var tab_height:Number = tab_content_height / tabs_counter;
				icon_holder.y = (i - 1) * tab_height + tab_height / 2;
				icon_holder.x = tab_width / 2;
			}
		}
		
		public function drawTabArea(spr:Object, tab_num:Number, border_color:Number = 0x000000, bg_color:Number = 0xcccccc):void {
			var tab_height:Number = tab_content_height / tabs_counter;
			spr.graphics.clear();
			spr.graphics.lineStyle(1, border_color);
			spr.graphics.beginFill(bg_color);
			spr.graphics.moveTo(tab_width,0);
			spr.graphics.lineTo(tab_width,(tab_num-1)*tab_height);
			spr.graphics.lineTo(0,(tab_num-1)*tab_height);
			spr.graphics.lineTo(0,tab_num*tab_height-1);
			spr.graphics.lineTo(tab_width, tab_num * tab_height-1);
			/*if (tab_num == tabs_counter) {
					
			}else {
	
			}*/
			spr.graphics.lineTo(tab_width, tab_content_height - 1);
			spr.graphics.lineTo(tab_content_width, tab_content_height - 1);	
			spr.graphics.lineTo(tab_content_width, 0);
			spr.graphics.endFill();
		}
		
		
		
		
		
	}

}