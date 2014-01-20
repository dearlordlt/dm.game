package dm.game.systems.render {
	
	import com.greensock.loading.ImageLoader;
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.loaders.Flare3DLoader;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.system.ILibraryExternalItem;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import net.richardlord.ash.signals.Signal2;
	import ucc.error.IllegalArgumentException;
	import utils.Utils;
	import utils.VideoTexture3D;
	
	/**
	 * Skin factory
	 * @version $Id: SkinFactory.as 162 2013-06-13 11:37:29Z zenia.sorocan $
	 */
	public class SkinFactory extends EventDispatcher {
		
		/** Default scene */
		public static var defaultScene:Scene3D;
		
		/**
		 * Class constructor
		 */
		public function SkinFactory() {
		
		}
		
		public static function createSkin(skinInfo:Object, recipient:SkinRecipient, scene:Scene3D = null):void {
			//trace("SkinFactory.createSkin(): " + skinInfo.label);
			if (!scene) {
				if (!defaultScene)
					throw new IllegalArgumentException("dm.game.systems.render.SkinFactory.createSkin() : Scene and default scene is null!");
				scene = defaultScene;
			}
			new SkinLoader(scene, skinInfo, recipient);
		}
	}
}