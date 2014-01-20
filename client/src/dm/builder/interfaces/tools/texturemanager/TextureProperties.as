package dm.builder.interfaces.tools.texturemanager {
	import com.bit101.components.InputText;
	import dm.builder.interfaces.BuilderLabel;
	import dm.builder.interfaces.BuilderWindow;
	import flare.core.Pivot3D;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class TextureProperties extends BuilderWindow {
		private var _selectedPart:Pivot3D;
		
		private var repeatX_ti:InputText;
		private var repeatY_ti:InputText;
		
		public function TextureProperties(parent:DisplayObjectContainer, selectedPart:Pivot3D) {
			_selectedPart = selectedPart;
			super(parent, "Texture properties");			
		}
		
		override protected function createGUI():void {
			var currentValue:String;
			
			currentValue = TextureFilter(Shader3D(_selectedPart.getMaterialByName("texture")).filters[0]).repeatX.toString();
			var repeatX_lbl:BuilderLabel = new BuilderLabel(_body, 10, 10, "RepeatX: ");
			repeatX_ti = new InputText(_body, repeatX_lbl.x + repeatX_lbl.textWidth + 5, repeatX_lbl.y, currentValue, onPropsChange);
			
			currentValue = TextureFilter(Shader3D(_selectedPart.getMaterialByName("texture")).filters[0]).repeatY.toString();
			var repeatY_lbl:BuilderLabel = new BuilderLabel(_body, repeatX_lbl.x, repeatX_ti.y + 30, "RepeatY: ");
			repeatY_ti = new InputText(_body, repeatY_lbl.x + repeatY_lbl.textWidth + 5, repeatY_lbl.y, currentValue, onPropsChange);
		
		/*var create_btn:PushButton = new PushButton(_body, _width * 0.5, name_lbl.y + name_lbl.textHeight + 20, "Create", onCreateBtn);
		 create_btn.x -= create_btn.width * 0.5;*/
		}
		
		private function onPropsChange(e:Event):void {
			TextureFilter(Shader3D(_selectedPart.getMaterialByName("texture")).filters[0]).repeatX = int(repeatX_ti.text);
			TextureFilter(Shader3D(_selectedPart.getMaterialByName("texture")).filters[0]).repeatY = int(repeatY_ti.text);
		}
	
	}

}