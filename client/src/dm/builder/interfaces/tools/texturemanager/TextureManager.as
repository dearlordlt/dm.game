package dm.builder.interfaces.tools.texturemanager {
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import flare.core.Texture3D;
	import flare.materials.filters.TextureFilter;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import net.richardlord.ash.signals.Signal2;
	import utils.AMFPHP;
	import utils.VideoTexture3D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TextureManager extends BuilderWindow {
		
		private var _textureCount:int = 0;
		private var _allTextureInfos:Array;
		private var _textureInfosToDisplay:Array;
		private var _textureHolders:Array = new Array();
		private var _standalone:Boolean;
		
		private var _textureInfoToBitmap:Dictionary = new Dictionary();
		
		private var _curPage:int = 0;
		
		private const TEXTURES_IN_ROW:int = 4;
		private const ROWS_ON_SCREEN:int = 3;
		private const TEXTURES_ON_PAGE:int = TEXTURES_IN_ROW * ROWS_ON_SCREEN;
		private const TEXTURE_WIDTH:int = 128;
		
		private var search_ti:InputText;
		private var prevPage_btn:PushButton;
		private var prevPage_lbl:BuilderLabel;
		private var nextPage_btn:PushButton;
		private var nextPage_lbl:BuilderLabel;
		private var type_cb:ComboBox;
		
		public var textureSelectedSignal:Signal2 = new Signal2(Object, TextureFilter);;
		
		public function TextureManager(parent:DisplayObjectContainer, standalone:Boolean = true) {
			super(parent, "Texture manager", 555, 550);			
			_standalone = standalone;			
			loadData();
		}
		
		private function onTypeSelect(e:Event):void {
			onSearch(null);
		}
		
		private function onNextPageBtn(e:MouseEvent):void {
			_curPage++;
			displayTextures();
		}
		
		private function onPrevPageBtn(e:MouseEvent):void {
			_curPage--;
			displayTextures();
		}
		
		private function onNewTextureBtn(e:MouseEvent):void {
			new NewTexture(parent);
		}
		
		private function onSearch(e:Event):void {
			_curPage = 0;
			_textureInfosToDisplay.splice(0);
			for each (var textureInfo:Object in _allTextureInfos)
				if (String(textureInfo.label).indexOf(search_ti.text) == 0 && textureInfo.type == type_cb.selectedItem.type)
					_textureInfosToDisplay.push(textureInfo);
			displayTextures();
		}
		
		public function loadData():void {
			createDummy();
			var loading_lbl:BuilderLabel = new BuilderLabel(_dummy, 50, 50, "Loading...");
			
			var amfphp:AMFPHP = new AMFPHP(onTextureInfo);
			amfphp.xcall("dm.Skin3D.getAllTextures");
			
			function onTextureInfo(response:Object):void {
				trace(response.length);
				_allTextureInfos = response as Array;
				_textureInfosToDisplay = _allTextureInfos.concat();
				onSearch(null);
				destroyDummy();
			}
		}
		
		private function displayTextures():void {
			var textureHolder:BuilderWindow;
			for each (textureHolder in _textureHolders)
				textureHolder.destroy();
			_textureHolders.splice(0);
			var colCounter:int = 0;
			_textureCount = 0;
			
			var texturesOnCurrentPage:int = (_textureInfosToDisplay.length < _curPage * TEXTURES_ON_PAGE + TEXTURES_ON_PAGE) ? _textureInfosToDisplay.length : _curPage * TEXTURES_ON_PAGE + TEXTURES_ON_PAGE;
			for (var i:int = _curPage * TEXTURES_ON_PAGE; i < texturesOnCurrentPage; i++) {
				var textureInfo:Object = _textureInfosToDisplay[i];
				
				textureHolder = new BuilderWindow(_body, textureInfo.label, TEXTURE_WIDTH + 2, TEXTURE_WIDTH + 2);
				_textureHolders.push(textureHolder);
				textureHolder.hideButtons();
				textureHolder.movable = false;
				textureHolder.x = 5 + (textureHolder.width + 5) * colCounter;
				textureHolder.y = 55 + (textureHolder.height + 5) * Math.floor(_textureCount / TEXTURES_IN_ROW);
				
				colCounter++;
				if (colCounter >= TEXTURES_IN_ROW)
					colCounter = 0;
				_textureCount++;
				
				switch (int(textureInfo.skin_type)) {
					case 0: 
						var imgVars:ImageLoaderVars = new ImageLoaderVars();
						imgVars.container(textureHolder.body);
						imgVars.height(TEXTURE_WIDTH);
						imgVars.width(TEXTURE_WIDTH);
						imgVars.onComplete(onTextureLoaded);
						var imgLoader:ImageLoader = new ImageLoader(textureInfo.path, imgVars);
						_textureInfoToBitmap[imgLoader.content] = textureInfo;
						imgLoader.load();
						break;
					case 1: 
						var video_lbl:BuilderLabel = new BuilderLabel(textureHolder.body, textureHolder.body.width * 0.5, textureHolder.bodyHeight * 0.5, "Video");
						video_lbl.x -= video_lbl.textWidth * 0.5;
						_textureInfoToBitmap[textureHolder.body] = textureInfo;
						if (!_standalone)
							textureHolder.body.addEventListener(MouseEvent.CLICK, onVideoTextureClick);
						break;
				}
			}
			
			nextPage_btn.visible = (_curPage + 1) * TEXTURES_ON_PAGE < _textureInfosToDisplay.length;
			nextPage_lbl.visible = (_curPage + 1) * TEXTURES_ON_PAGE < _textureInfosToDisplay.length;
			
			if (_textureHolders.length < TEXTURES_ON_PAGE) {
				nextPage_btn.visible = false;
				nextPage_lbl.visible = false;
			}
			
			prevPage_btn.visible = (_curPage + 1) * TEXTURES_ON_PAGE > TEXTURES_ON_PAGE;
			prevPage_lbl.visible = (_curPage + 1) * TEXTURES_ON_PAGE > TEXTURES_ON_PAGE;
		}
		
		private function onVideoTextureClick(e:MouseEvent):void {
			var textureInfo:Object = _textureInfoToBitmap[e.currentTarget];
			var texture:VideoTexture3D = new VideoTexture3D(textureInfo.path, 256, 256);
			var textureFilter:TextureFilter = new TextureFilter(texture);
			textureSelectedSignal.dispatch(textureInfo, textureFilter);
		}
		
		private function onTextureLoaded(e:Event):void {
			if (!_standalone)
				ImageLoader(e.currentTarget).content.addEventListener(MouseEvent.CLICK, onBitmapTextureClick);
		}
		
		private function onBitmapTextureClick(e:MouseEvent):void {
			var bitmap:Bitmap = ContentDisplay(e.currentTarget).rawContent as Bitmap;
			var textureFilter:TextureFilter = new TextureFilter(new Texture3D(bitmap));
			textureFilter.repeatX = 2;
			textureFilter.repeatY = 2;
			textureSelectedSignal.dispatch(_textureInfoToBitmap[e.currentTarget], textureFilter);
		}
		
		override protected function createGUI():void {
			var search_lbl:BuilderLabel = new BuilderLabel(_body, 5, 10, "Search: ");
			search_ti = new InputText(_body, search_lbl.x + search_lbl.textWidth + 5, search_lbl.y, "", onSearch);
			
			var type_lbl:BuilderLabel = new BuilderLabel(_body, search_ti.x + search_ti.width + 30, search_ti.y, "Type: ");
			type_cb = new ComboBox(_body, type_lbl.x + type_lbl.textWidth + 5, type_lbl.y, "", [{label: "Bitmap", type: "diff"}, {label: "Video", type: "video"}]);
			type_cb.selectedIndex = 0;
			type_cb.addEventListener(Event.SELECT, onTypeSelect);
			
			var orderBy_lbl:BuilderLabel = new BuilderLabel(_body, search_ti.x + search_ti.width + 30, search_ti.y, "Order by: ");
			var orderBy_cb:ComboBox = new ComboBox(_body, orderBy_lbl.x + orderBy_lbl.textWidth + 5, orderBy_lbl.y, "", ["name", "date", "category"]);
			orderBy_lbl.visible = false;
			orderBy_cb.visible = false;
			
			var newTexture_btn:PushButton = new PushButton(_body, orderBy_cb.x + orderBy_cb.width + 40, orderBy_cb.y, "New texture", onNewTextureBtn);
			
			prevPage_btn = new PushButton(_body, 20, bodyHeight - 20, "<", onPrevPageBtn);
			prevPage_btn.width = 20;
			prevPage_btn.height = 15;
			prevPage_lbl = new BuilderLabel(_body, prevPage_btn.x + prevPage_btn.width + 5, prevPage_btn.y - 2, "Previous page");
			
			prevPage_btn.visible = false;
			prevPage_lbl.visible = false;
			
			nextPage_btn = new PushButton(_body, _width - 40, bodyHeight - 20, ">", onNextPageBtn);
			nextPage_btn.width = 20;
			nextPage_btn.height = 15;
			nextPage_lbl = new BuilderLabel(_body, nextPage_btn.x - 10, nextPage_btn.y - 2, "Next page");
			nextPage_lbl.x -= nextPage_lbl.textWidth;
			nextPage_lbl.width = nextPage_lbl.textWidth + 5;
			
			nextPage_btn.visible = false;
			nextPage_lbl.visible = false;
		}
		
		override public function destroy():void {
			textureSelectedSignal.removeAll();
			super.destroy();
		}
	
	}

}