package dm.game.windows.minimap {
	
	import dm.game.components.AvatarLabel;
	import dm.game.components.InputController;
	import dm.game.components.Interaction;
	import dm.game.components.NPC;
	import dm.game.components.Skin3D;
	import dm.game.managers.EntityManager;
	import dm.game.managers.EsManager;
	import dm.game.managers.MyManager;
	import dm.game.managers.UserManager;
	import dm.game.windows.DmWindow;
	import flare.core.Pivot3D;
	import flare.utils.Matrix3DUtils;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import net.richardlord.ash.core.Entity;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class Minimap extends DmWindow {
		
		private const MINIMAP_WIDTH:int = 300;
		private const MINIMAP_HEIGHT:int = 300;
		
		private var _scaling:Number = 0.1;
		
		private const TYPE_NPC:uint = 0x008000;
		private const TYPE_INTERACTION:uint = 0xCCCCCC;
		private const TYPE_AVATAR:uint = 0xFF0000;
		private const TYPE_MY_AVATAR:uint = 0x0000FF;
		private const TYPE_QUEST:uint = 0xFF00FF;
		
		private var _objectMarkers:Array = new Array();
		private var _questMarkers:Array = new Array();
		
		private var _myMarkerSprite:Sprite;
		
		private var _mapArea:Sprite;
		private var _mapMask:Sprite;
		
		//private var 
		
		public function Minimap(parent:DisplayObjectContainer) {
			super(parent, _("Minimap"), MINIMAP_WIDTH, MINIMAP_HEIGHT);
		}
		
		public override function initialize():void {
			addEntitiesToMinimap();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			UserManager.instance.userAvatarCreatedSignal.add(onUserAvatarCreated);
			
			//addQuestMarker("WOW", -930, -100);
		}
		
		private function addDirectionToMarker(marker:Object):void {
			var arrowDistance:int = 90;
			var directionArrow:Sprite = new Sprite();
			directionArrow.graphics.beginFill(marker.type);
			directionArrow.graphics.moveTo(arrowDistance, -10);
			directionArrow.graphics.lineTo(arrowDistance + 20, 0);
			directionArrow.graphics.lineTo(arrowDistance, 10);
			directionArrow.graphics.lineTo(arrowDistance, 5);
			directionArrow.graphics.lineTo(arrowDistance + 15, 0);
			directionArrow.graphics.lineTo(arrowDistance, -5);
			directionArrow.graphics.lineTo(arrowDistance, -10);
			directionArrow.graphics.endFill();
			
			_mapArea.addChild(directionArrow);
			
			//directionArrow.x = 50;
			//directionArrow.y = 50;
			
			marker.direction = directionArrow;
		
		}
		
		private function addQuestMarker(label:String, x:int, y:int):void {
			var marker:Object = {sprite: createMarker(TYPE_QUEST), type: TYPE_QUEST, label: label, originalX: x, originalY: -y};
			addDirectionToMarker(marker);
			_questMarkers.push(marker);
		}
		
		public function refreshQuestMarkers():void {
			var amfphp:AMFPHP = new AMFPHP(onQuests).xcall("dm.Quest.getAllQuestsForAvatar", MyManager.instance.avatar.id);
			function onQuests(response):void {
				for each (var marker:Object in _questMarkers) {
					_mapArea.removeChild(marker.sprite);
					_mapArea.removeChild(marker.direction);
				}
				_questMarkers.length = 0;
				
				for each(var quest:Object in response) {
					
					// if ( ( quest.map_label == EsManager.instance.roomData.map_label ) && ( quest.completed == 0 ) )
					if ( ( quest.room_label == EsManager.instance.room.name ) && ( quest.completed == 0 ) ) {
						addQuestMarker(quest.label, quest.marker_x, quest.marker_y);
					}
				}
			}
		}
		
		private function onUserAvatarCreated(userName:String):void {
			var entity:Entity = UserManager.instance.usersToEntities[userName];
			_objectMarkers.push({type: TYPE_AVATAR, entity: entity, sprite: createMarker(TYPE_AVATAR)});
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			_scaling += e.delta * 0.005;
			if (_scaling < 0)
				_scaling = 0;
		}
		
		private function onEnterFrame(e:Event):void {
			var offsetX:int = (MINIMAP_WIDTH - 20) * 0.5 - MyManager.instance.skin.x * _scaling;
			var offsetY:int = (MINIMAP_HEIGHT - 50) * 0.5 + MyManager.instance.skin.z * _scaling;
			
			for each (var marker:Object in _objectMarkers) {
				try {
					var skin:Pivot3D = Skin3D(Entity(marker.entity).get(Skin3D)).skin as Pivot3D;
					marker.sprite.x = skin.x * _scaling + offsetX;
					marker.sprite.y = (-skin.z * _scaling + offsetY);
					var dir:Vector3D = Matrix3DUtils.getDir(skin.global);
					marker.sprite.rotation = -Math.atan2(-dir.z, dir.x) * 180 / Math.PI;
					if (marker.type == TYPE_MY_AVATAR) {
						var dir:Vector3D = Matrix3DUtils.getDir(skin.global);
						marker.sprite.rotation = Math.atan2(-dir.z, dir.x) * 180 / Math.PI;
						marker.sprite.rotation += 180;
						//trace("Skin: " + skin.getRotation().y + " (" + skin.x + ", " + skin.z + ") | Marker: " + marker.sprite.rotation);
					}
				} catch (err:Error) {
					//trace("Minimap: Skin is gone. Deleting marker...");
					_mapArea.removeChild(marker.sprite);
					_objectMarkers.splice(_objectMarkers.indexOf(marker), 1);
				}
			}
			
			for each (var marker:Object in _questMarkers) {
				marker.sprite.x = marker.originalX * _scaling + offsetX;
				marker.sprite.y = marker.originalY * _scaling + offsetY;
				if (marker.direction)
					if (!_mapMask.hitTestObject(marker.sprite)) {
						marker.direction.visible = true;
						marker.direction.x = _myMarkerSprite.x;
						marker.direction.y = _myMarkerSprite.y;
						marker.direction.rotation = Math.atan2(marker.sprite.y - marker.direction.y, marker.sprite.x - marker.direction.x) / Math.PI * 180;
					} else {
						marker.direction.visible = false;
					}
			}
		}
		
		private function addEntitiesToMinimap():void {
			var sprite:Sprite;
			for each (var entity:Entity in EntityManager.instance.entities) {
				if (entity.has(NPC)) {
					sprite = createMarker(TYPE_NPC);
					_objectMarkers.push({type: TYPE_NPC, entity: entity, sprite: sprite});
				}
				
				if (entity.has(Interaction) && !entity.has(NPC)) {
					sprite = createMarker(TYPE_INTERACTION);
					_objectMarkers.push({type: TYPE_INTERACTION, entity: entity, sprite: sprite});
				}
				
				if (entity.has(AvatarLabel) && !entity.has(NPC)) {
					sprite = createMarker(TYPE_AVATAR);
					_objectMarkers.push({type: TYPE_AVATAR, entity: entity, sprite: sprite});
				}
				
				if (entity.has(InputController)) {
					sprite = createMarker(TYPE_MY_AVATAR);
					_myMarkerSprite = sprite;
					_objectMarkers.push({type: TYPE_MY_AVATAR, entity: entity, sprite: sprite});
				}
				
				if (sprite && Skin3D(Entity(entity).get(Skin3D)).skin) {
					sprite.name = Skin3D(Entity(entity).get(Skin3D)).skin.name;
					sprite.x = Skin3D(Entity(entity).get(Skin3D)).skin.x * _scaling;
					sprite.y = Skin3D(Entity(entity).get(Skin3D)).skin.z * _scaling;
					sprite.addEventListener(MouseEvent.ROLL_OVER, onMarkerRollOver);
				}
			}
		
		}
		
		private function onMarkerRollOver(e:MouseEvent):void {
			trace(e.currentTarget.name);
		}
		
		private function createMarker(type:uint):Sprite {
			var marker:Sprite = new Sprite();
			_mapArea.addChild(marker);
			
			marker.graphics.beginFill(type);
			
			if (type != TYPE_MY_AVATAR/* && type != TYPE_INTERACTION*/) {
				marker.graphics.drawEllipse(-5, -5, 10, 10);
			} else {
				marker.graphics.moveTo(-5, -5);
				marker.graphics.lineTo(10, 0);
				marker.graphics.lineTo(-5, 5);
				marker.graphics.lineTo(-5, -5);
			}
			marker.graphics.endFill();
			
			return marker;
		}
		
		override public function draw():void {
			super.draw();
			
			_mapArea = new Sprite();
			addChild(_mapArea);
			_mapArea.graphics.lineStyle(1);
			_mapArea.graphics.beginFill(0, 0.5);
			_mapArea.graphics.drawRect(0, 0, MINIMAP_WIDTH - 20, MINIMAP_HEIGHT - 50);
			_mapArea.graphics.endFill();
			
			_mapArea.x = 10;
			_mapArea.y = 40;
			
			_mapMask = new Sprite();
			addChild(_mapMask);
			_mapMask.graphics.lineStyle(1);
			_mapMask.graphics.beginFill(0, 1);
			_mapMask.graphics.drawRect(0, 0, MINIMAP_WIDTH - 20, MINIMAP_HEIGHT - 50);
			_mapMask.graphics.endFill();
			
			_mapMask.x = 10;
			_mapMask.y = 40;
			
			_mapArea.mask = _mapMask;
		}
		
		override public function getInitialPosition():Point {
			return new Point(stage.stageWidth - MINIMAP_WIDTH - 10, 10);
		}
		
		override public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			super.destroy();
		}
	
	}

}