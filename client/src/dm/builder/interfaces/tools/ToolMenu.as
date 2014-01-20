package dm.builder.interfaces.tools {
	
	import dm.builder.interfaces.dropdownmenu.DropDownMenu;
	import dm.builder.interfaces.tools.altskinmanager.AlteringSkinManager;
	import dm.builder.interfaces.tools.charactereditor.CharacterEditor;
	import dm.builder.interfaces.tools.custombuildingeditor.CustomBuildingEditor;
	import dm.builder.interfaces.tools.environmentstateeditor.EnvironmentStateEditor;
	import dm.builder.interfaces.tools.looteditor.LootEditor;
	import dm.builder.interfaces.tools.mediamanager.MediaManager;
	import dm.builder.interfaces.tools.npceditor.NpcEditor;
	import dm.builder.interfaces.tools.quest.QuestsManager;
	import dm.builder.interfaces.tools.roomeditor.RoomEditor;
	import dm.builder.interfaces.tools.solidobjecteditor.SolidObjectEditor;
	import dm.builder.interfaces.tools.texturemanager.TextureManager;
	import dm.game.windows.DmWindowManager;
	import dm.minigames.artgame.ArtGame;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import org.as3commons.lang.ClassUtils;
	import ucc.logging.Logger;
	import ucc.project.dialog_editor.DialogEditor;
	import ucc.project.tag.TagsManager;
	// import CONFIG::DIALOG_EDITOR_CLASS;
	// import dm.builder.interfaces.tools.dialogeditor.DialogEditor;
	
	/**
	 * ...
	 * @author
	 */
	public class ToolMenu extends DropDownMenu {
		
		// just for including those classes into SWF
		// public var d1 : dm.builder.interfaces.tools.dialogeditor.DialogEditor;
		public var d2 : ucc.project.dialog_editor.DialogEditor;
		
		public function ToolMenu(parent:DisplayObjectContainer, permissions:Array) {
			super(parent, _("Tools"));
			/*
			addItem({label: _("Custom building editor"), onClick: onBuildingEditor});
			addItem({label: _("Character builder"), onClick: onCharacterBuilder});
			addItem({label: _("Solid object editor"), onClick: onSolidObjectEditor});
			addItem({label: _("Texture manager"), onClick: onTextureManager});
			addItem({label: _("Object uploader"), onClick: onObjectUploader});
			addItem({label: _("NPC editor"), onClick: onNpcEditor});
			addItem({label: _("Interaction editor"), onClick: onInteractionEditor});
			addItem({label: _("Item editor"), onClick: onItemEditor});
			addItem({label: _("Audio editor"), onClick: onAudioEditor});
			addItem({label: "Dialog editor", onClick: onDialogEditor});
			addItem({label: "Loot editor", onClick: onLootEditor});
			*/
			var menuItems:Array = [
			{label: _("Custom building editor"), onClick: onBuildingEditor },
			{label: _("Character builder"), onClick: onCharacterBuilder },
			{label: _("Solid object editor"), onClick: onSolidObjectEditor },
			{label: _("Texture manager"), onClick: onTextureManager },
			{label: _("Object uploader"), onClick: onObjectUploader },
			{label: _("NPC editor"), onClick: onNpcEditor },
			{label: _("Interaction editor"), onClick: onInteractionEditor },
			{label: _("Item editor"), onClick: onItemEditor },
			{label: _("Audio editor"), onClick: onAudioEditor },
			{label: _("Dialog editor"), onClick: onDialogEditor },
			{label: "Loot editor", onClick: onLootEditor },
			{label: "Object permission editor", onClick: onObjectPermissionEditor },
			{label:_("Vars editor"), onClick: this.onVarsEditorClick },
			{label: _("ArtGame editor"), onClick: onArtGameEditor },
			{label: _("Media manager"), onClick: onMediaManager },
			{label: _("Altering skin manager"), onClick: onAltSkinManager },
			{label: _("Category manager"), onClick: onCategoryManager },
			{label: _("Shop Editor"), onClick: onShopEditor },
			{label: _("Quests manager"), onClick: onQuestsManagerClick },
			{label: _("Environment state editor"), onClick: onEnvironmentStateEditoClick },
			{label: _("Room editor"), onClick: onRoomEditorClick }
			];
			
			if (permissions) {
				for (var i:int = 0; i < permissions.length; i++) {
					if (permissions[i] == "true") {
						if (menuItems[i]) {
							this.addItem(menuItems[i]);
						} else {
							Logger.log("dm.builder.interfaces.tools.ToolsMenu.ToolsMenu() : Trying to set permissions for non existing menu item at index: " + i, Logger.LEVEL_WARN);
						}
						
					}
					
				}
			} else {
				for each (var item:Object in menuItems) {
					this.addItem(item);
				}
			}
		}
		
		private function onRoomEditorClick():void 
		{
			new RoomEditor();
		}
		
		private function onEnvironmentStateEditoClick():void 
		{
			new EnvironmentStateEditor();
		}
		
		private function onShopEditor():void 
		{
			new ShopEditor(null);
		}
		
		private function onCategoryManager():void 
		{
			new CategoryEditor(null);
		}
		
		private function onAltSkinManager():void 
		{
			new AlteringSkinManager(null);
		}
		
		private function onArtGameEditor():void 
		{
			var artGame:ArtGame = new ArtGame("backend");
			DmWindowManager.instance.windowLayer.addChild(artGame);
		}
		
		private function onObjectPermissionEditor():void 
		{
			new ObjectPermissionManager();
		}
		
		private function onLootEditor():void {
			new LootEditor( null );
		}
		
		
		private function onDialogEditor():void {
			/*
			if ( CONFIG::DIALOG_EDITOR_CLASS == "dm.builder.interfaces.tools.dialogeditor.DialogEditor" ) {
				// var dialogEditor:DialogEditor = new DialogEditor(1, "http://vds000004.hosto.lt/amfphp/gateway.php");
				var dialogEditor : * = ClassUtils.newInstance( getDefinitionByName( CONFIG::DIALOG_EDITOR_CLASS ) as Class, [ 1, "http://vds000004.hosto.lt/amfphp/gateway.php" ] );
				parent.addChild(dialogEditor);
			} else {
				// new DialogEditor();
			*/
				ClassUtils.newInstance( getDefinitionByName( CONFIG::DIALOG_EDITOR_CLASS ) as Class );
			/*}*/
		}
		
		private function onAudioEditor():void {
			new AudioEditor( null );
		}
		
		private function onItemEditor():void {
			new ItemEditor( null );
		}
		
		private function onInteractionEditor():void {
			new InteractionEditor( null );
		}
		
		private function onNpcEditor():void {
			new NpcEditor( null );
		}
		
		private function onObjectUploader():void {
			new ObjectUploader( null );
		}
		
		private function onSolidObjectEditor():void {
			new SolidObjectEditor( null);
		}
		
		private function onTextureManager():void {
			new TextureManager(null);
		}
		
		private function onCharacterBuilder():void {
			new CharacterEditor(null);
		}
		
		private function onBuildingEditor():void {
			new CustomBuildingEditor(null);
		}
		
		private function onQuestsManagerClick () : void {
			new QuestsManager();
		}
		
		/**
		 *	On vars editor click
		 */
		protected function onVarsEditorClick () : void {
			new TagsManager();
		}
		
		/**
		 *	On media manager
		 */
		protected function onMediaManager () : void {
			new MediaManager( null );
		}
	
	}

}