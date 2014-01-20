package tests {
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.NormalMapFilter;
	import flare.materials.filters.SpecularMapFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Shader3D;
	import flare.system.Input3D;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class CharStressTest {
		
		private const CHARS_IN_ROW:int = 10;
		private const CHARS_IN_COL:int = 10;
		private const DISTANCE_BETWEEN_ROWS:int = 500;
		private const DISTANCE_BETWEEN_COLS:int = 500;
		
		private var _scene:Scene3D;
		
		private var char:Pivot3D;
		
		private var bottom:Pivot3D = new Pivot3D("bottom");
		private var top:Pivot3D = new Pivot3D("top");
		private var head:Pivot3D = new Pivot3D("head");
		private var hair:Pivot3D = new Pivot3D("hair");
		
		public function CharStressTest(scene:Scene3D) {
			
			_scene = scene;
			
			char = new Pivot3D();
			_scene.addChild(char);
			
			scene.addChildFromFile("assets/characters/professor_m/professor_m_bottom_3.f3d", bottom);
			scene.addChildFromFile("assets/characters/professor_m/professor_m_top_3.f3d", top);
			scene.addChildFromFile("assets/characters/professor_m/professor_m_head_3.f3d", head);
			scene.addChildFromFile("assets/characters/professor_m/professor_m_hair_3.f3d", hair);
			
			char.addChild(bottom);
			char.addChild(top);
			char.addChild(head);
			char.addChild(hair);
			
			/*
			   bottom.stop();
			   top.stop();
			   head.stop();
			   hair.stop();
			 */
			
			_scene.addEventListener(Scene3D.COMPLETE_EVENT, onSceneComplete);
			_scene.addEventListener(Scene3D.UPDATE_EVENT, onSceneUpdate);
		}
		
		private function onSceneUpdate(e:Event):void {
			if (Input3D.keyHit(Input3D.F3))
				setTextures();
		}
		
		private function onSceneComplete(e:Event):void {
			_scene.removeEventListener(Scene3D.COMPLETE_EVENT, onSceneComplete);
			
			//char.addEventListener(Pivot3D.ENTER_FRAME_EVENT, onCharEnterFrame);
			
			for each (var part:Pivot3D in char.children)
				for each (var inner_part:Pivot3D in part.children)
					if (inner_part is Mesh3D)
						inner_part.currentFrame = 0;
			
			setTextures();
			
			for (var i:int = 0; i < CHARS_IN_ROW; i++) {
				for (var j:int = 0; j < CHARS_IN_COL; j++) {
					var char_clone:Pivot3D = char.clone();
					_scene.addChild(char_clone);
					char_clone.x = i * DISTANCE_BETWEEN_COLS;
					char_clone.z = j * DISTANCE_BETWEEN_ROWS;
					char_clone.play();
				}
			}
		
		}
		
		private function onCharEnterFrame(e:Event):void {
			for each (var part:Pivot3D in char.children)
				for each (var inner_part:Pivot3D in part.children)
					if (inner_part is Mesh3D)
						trace(inner_part.name + ": " + inner_part.currentFrame);
			trace();
		}
		
		private function setTextures():void {
			trace("Setting textures");
			
			var cf:ColorFilter = new ColorFilter(0xFF0000);
			
			var bottom_mat:Shader3D = new Shader3D("", null, true, Shader3D.VERTEX_SKIN);
			
			var bottom_diff:TextureFilter = new TextureFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_bottom_3_diff.png"));
			var bottom_nmf:NormalMapFilter = new NormalMapFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_bottom_3_nml.png"));
			var bottom_smf:SpecularMapFilter = new SpecularMapFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_bottom_3_spm.png"));
			bottom_mat.filters = [cf, bottom_diff, bottom_nmf, bottom_smf];
			
			bottom.setMaterial(bottom_mat);
			
			var top_mat:Shader3D = new Shader3D("", null, true, Shader3D.VERTEX_SKIN);
			var top_diff:TextureFilter = new TextureFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_top_3_diff.png"));
			var top_nmf:NormalMapFilter = new NormalMapFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_top_3_nml.png"));
			var top_smf:SpecularMapFilter = new SpecularMapFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_top_3_spm.png"));
			top_mat.filters = [cf, top_diff, top_nmf, top_smf];
			
			top.setMaterial(top_mat);
			
			var head_mat:Shader3D = new Shader3D("", null, true, Shader3D.VERTEX_SKIN);
			var head_diff:TextureFilter = new TextureFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_head_3_diff.png"));
			var head_nmf:NormalMapFilter = new NormalMapFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_head_3_nml.png"));
			var head_smf:SpecularMapFilter = new SpecularMapFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_head_3_spm.png"));
			head_mat.filters = [cf, head_diff, head_nmf, head_smf];
			
			head.setMaterial(head_mat);
			
			var hair_mat:Shader3D = new Shader3D("", null, true, Shader3D.VERTEX_SKIN);
			var hair_diff:TextureFilter = new TextureFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_hair_3_diff.png"));
			var hair_nmf:NormalMapFilter = new NormalMapFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_hair_3_nml.png"));
			var hair_smf:SpecularMapFilter = new SpecularMapFilter(new Texture3D("assets/textures/character/professor_m/didesni/professor_m_hair_3_spm.png"));
			hair_mat.filters = [cf, hair_diff, hair_nmf, hair_smf];
			
			hair.setMaterial(hair_mat);
		}
	
	}

}