package dm.builder.interfaces.components {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import dm.game.components.AvatarSpawnPoint;
	import dm.game.managers.EntityManager;
	import dm.game.managers.MapManager;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.richardlord.ash.core.Entity;
	
	/**
	 * ...
	 * @author
	 */
	public class ComponentHolder extends BuilderWindow {
		
		private var _componentContainer:Sprite;
		private var _componentViews:Vector.<BuilderWindow> = new Vector.<BuilderWindow>();
		private var _componentViewMap:ComponentViewMap = new ComponentViewMap();
		
		private var destroy_btn:PushButton;
		private var addComponent_btn:PushButton;
		private var label_ti:InputText;
		private var label_lbl:BuilderLabel;
		
		public function ComponentHolder(parent:DisplayObjectContainer) {
			super(parent, "No entity selected", 220, parent.stage.stageHeight);
		
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function initialize():void {
			
			EntityManager.instance.entitySelectedSignal.add(onEntitySelect);
			EntityManager.instance.componentAddedSignal.add(onComponentAdd);
			EntityManager.instance.componentRemovedSignal.add(onComponentRemove);
			EntityManager.instance.entityRemovedSignal.add(onEntityRemove);
			MapManager.instance.mapLoadedSignal.add(onMapLoaded);
		}
		
		private function onMapLoaded():void {
			displayEnity(EntityManager.instance.currentEntity);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function draw():void {
			super.draw();
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, -1);
		}
		
		private function onEntityRemove():void {
			//trace("ComponentHolder.onEntityRemove(): " + BuilderEntityManager.instance.currentEntity.label);
			if (EntityManager.instance.currentEntity == null) {
				label = "No entity selected";
				//useAsPreset_lbl.visible = false;
				//useAsPreset_cb.visible = false;
				destroy_btn.visible = false;
				addComponent_btn.visible = false;
				removeAllComponentViews();
			}
		}
		
		private function onEntitySelect(entity:Entity):void {
			displayEnity(entity);
		}
		
		private function onComponentAdd(entity:Entity, componentClass:Class):void {
			displayEnity(entity);
		}
		
		private function onComponentRemove(entity:Entity, componentClass:Class):void {
			if (entity == EntityManager.instance.currentEntity)
				displayEnity(entity);
		}
		
		public function displayEnity(entity:Entity):void {
			// don't show entity properties until map is loaded
			if (!MapManager.instance.mapLoaded)
				return;
			if (entity != null) {
				label = "Entity ID: " + entity.label;
				label_ti.text = entity.label;
				
				label_lbl.visible = true;
				label_ti.visible = true;
				destroy_btn.visible = true;
				addComponent_btn.visible = true;
				
				removeAllComponentViews();
				
				for each (var componentClass:Class in EntityManager.instance.entityComponents[entity]) {
					var viewClass:Class = _componentViewMap.getView(componentClass);
					if (viewClass != null)
						this.addComponentView(new viewClass(_componentContainer, entity.get(componentClass)));
				}
				
				addComponent_btn.visible = !entity.has(AvatarSpawnPoint);
			}
		}
		
		private function addComponentView(componentView:BuilderWindow):void {
			//trace("ComponentHolder.addComponentView()");
			_componentViews.push(componentView);
			componentView.addEventListener(BuilderWindow.EVENT_HEIGHT_CHANGE, onComponentViewHeightChange);
			
			if (_componentViews.length > 1)
				componentView.minimized = true;
			
			positionComponentViews();
		}
		
		private function onComponentViewHeightChange(e:Event):void {
			if (!BuilderWindow(e.currentTarget).minimized)
				for each (var component:BuilderWindow in _componentViews)
					if (component != e.currentTarget)
						component.minimized = true;
			positionComponentViews();
		}
		
		private function positionComponentViews():void {
			_componentViews[0].x = 0;
			_componentViews[0].y = 0;
			for (var i:int = 1; i < _componentViews.length; i++) {
				_componentViews[i].x = 0;
				_componentViews[i].y = _componentViews[i - 1].y + _componentViews[i - 1].curHeight + 5;
			}
		}
		
		private function removeAllComponentViews():void {
			for each (var componentView:BuilderWindow in _componentViews)
				componentView.destroy();
			_componentViews.length = 0;
		}
		
		override protected function createGUI():void {
			label_lbl = new BuilderLabel(_body, 10, 10, _("Label") + ": ");
			label_lbl.visible = false;
			label_ti = new InputText(_body, label_lbl.x + label_lbl.textWidth + 5, label_lbl.y, "", onLabelChange);
			label_ti.visible = false;
			
			addComponent_btn = new PushButton(_body, label_lbl.x, label_lbl.y + 30, _("Add component"), onAddComponentBtn);
			addComponent_btn.visible = false;
			destroy_btn = new PushButton(_body, addComponent_btn.x + addComponent_btn.width + 5, addComponent_btn.y, _("Destroy"), onDestroyBtn);
			destroy_btn.visible = false;
			
			_componentContainer = new Sprite();
			_body.addChild(_componentContainer);
			_componentContainer.y = 100;
			_componentContainer.x = 5;
		}
		
		private function onLabelChange(e:Event):void {
			EntityManager.instance.currentEntity.label = label_ti.text;
		}
		
		/**
		 *	On added to stage
		 */
		protected function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			this.stage.addEventListener(Event.RESIZE, this.onResize);
			this.onResize(null);
		}
		
		/**
		 * On resize
		 */
		protected function onResize(event:Event):void {
			this.x = stage.stageWidth - _width;
			this.y = 0;
		}
		
		private function onAddComponentBtn(e:MouseEvent):void {
			new SelectComponent(parent);
		}
		
		private function onDestroyBtn(e:MouseEvent):void {
			EntityManager.instance.removeEntity(EntityManager.instance.currentEntity);
		}
		
		override public function destroy():void {
			EntityManager.instance.entitySelectedSignal.remove(onEntitySelect);
			EntityManager.instance.componentAddedSignal.remove(onComponentAdd);
			EntityManager.instance.componentRemovedSignal.remove(onComponentRemove);
			EntityManager.instance.entityRemovedSignal.remove(onEntityRemove);
			
			super.destroy();
		}
	}
}