package dm.game.managers {
	import com.electrotank.electroserver5.api.EsObject;
	import com.electrotank.electroserver5.api.PluginMessageEvent;
	import com.electrotank.electroserver5.api.PluginRequest;
	import com.greensock.loading.data.MP3LoaderVars;
	import com.greensock.loading.MP3Loader;
	import dm.game.Main;
	import dm.game.systems.render.CustomParticle;
	import flare.core.ParticleEmiter3D;
	import flare.core.Texture3D;
	import flare.materials.filters.TextureFilter;
	import flare.materials.ParticleMaterial3D;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class EnvironmentStateManager {
		private const GAME_URL:String = "http://vds000004.hosto.lt/dm/";
		
		private var _currentParticleEmmiters:Array = new Array();
		private var _currentMp3Loaders:Array = new Array();
		
		private var _currentStateNum:int = 0;
		
		/** Current state */
		protected var currentState : Object;
		
		public function EnvironmentStateManager() {
			
			if ( EsManager.instance.roomData.states && ( EsManager.instance.roomData.states as Array ).length > 0 ) {
				
				var timer:Timer = new Timer(20000);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
				
				EsManager.instance.esPluginMessageSignal.add(onPluginMessage);
				this.setState(EsManager.instance.roomData.states[_currentStateNum]);
				
			}
			
		}
		
		private function onPluginMessage(e:PluginMessageEvent):void {
			
			try {
				var messageType:String = e.parameters.getString("type");
			} catch (error:Error) {
				return;
			}
			
			if (e.parameters.getString("type") == "serverTime") {
				var minutes:int = e.parameters.getInteger("hours") * 60 + e.parameters.getInteger("minutes");
				
				var stateNum:int = Math.ceil(minutes / EsManager.instance.roomData.state_duration);
				var cycleNum:int = Math.floor(stateNum / EsManager.instance.roomData.states.length);
				var currentStateNum:int = stateNum - (EsManager.instance.roomData.states.length * cycleNum);
				
				if ( ( currentStateNum != this._currentStateNum ) || !this.currentState || ( EsManager.instance.roomData.states.length == 1 ) ) {
					_currentStateNum = currentStateNum;
					setState(EsManager.instance.roomData.states[_currentStateNum]);
				}
			}
		}
		
		private function onTimer(e:TimerEvent):void {
			var pr:PluginRequest = new PluginRequest();
			pr.parameters = new EsObject();
			pr.pluginName = "DmExt";
			pr.parameters.setString("action", "getServerTime");
			EsManager.instance.es.engine.send(pr);
		}
		
		public function setState(state:Object):void {
			
			this.currentState = state;
			
			MapManager.instance.skybox = state.skybox;
			
			for each (var particleEmitter:ParticleEmiter3D in _currentParticleEmmiters) {
				Main.getInstance().getWorld3D().scene.removeChild(particleEmitter);
			}
			
			for each (var loader:MP3Loader in _currentMp3Loaders) {
				loader.pause();
				loader.dispose(true);
			}
			
			_currentMp3Loaders.length = 0;
			
			for each (var visualEffect:Object in state.visualEffects) {
				startParticleEffect(visualEffect);
			}
			
			for each (var audioEffect:Object in state.audioEffects) {
				startAudioEffect(audioEffect);
			}
		}
		
		private function startAudioEffect(audioEffect:Object):void {
			
			var loaderVars:MP3LoaderVars = new MP3LoaderVars().autoPlay(true).volume(audioEffect.volume / 100);
			var loader:MP3Loader = new MP3Loader(GAME_URL + audioEffect.audio_path, loaderVars);
			loader.load();
			_currentMp3Loaders.push(loader);
		}
		
		private function startParticleEffect(effect:Object):void {
			var texture:Texture3D = Main.getInstance().getWorld3D().scene.addTextureFromFile(GAME_URL + effect.texture_path);
			var particleMaterial:ParticleMaterial3D = new ParticleMaterial3D("", [new TextureFilter(texture)]);
			particleMaterial.build();
			var particleEmitter:ParticleEmiter3D = new ParticleEmiter3D("rain", particleMaterial, new CustomParticle(effect.fall_speed));
			particleEmitter.emitParticlesPerFrame = effect.intensity;
			particleEmitter.particlesLife = 100;
			Main.getInstance().getWorld3D().scene.addChild(particleEmitter);
			_currentParticleEmmiters.push(particleEmitter);
		}
	
	}

}