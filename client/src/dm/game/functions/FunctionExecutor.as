package dm.game.functions {
	import dm.game.friend.command.AddFriendCommand;
	import dm.game.friend.command.RemoveFriendCommand;
	import dm.game.functions.commands.AddQuestCommand;
	import dm.game.functions.commands.AskQuestionCommand;
	import dm.game.functions.commands.CompleteQuestCommand;
	import dm.game.functions.commands.GoHomeCommand;
	import dm.game.functions.commands.GoToHomeTownCommand;
	import dm.game.functions.commands.LootCommand;
	import dm.game.functions.commands.OpenDialogNodeCommand;
	import dm.game.functions.commands.OpenShopCommand;
	import dm.game.functions.commands.RefreshAltskinsCommand;
	import dm.game.functions.commands.RefreshInteractionsCommand;
	import dm.game.functions.commands.SetTimeoutCommand;
	import dm.game.functions.commands.UpdateAvatarSkinCommand;
	import dm.game.Main;
	import dm.game.managers.EsManager;
	import dm.game.managers.MyManager;
	import dm.game.media.OpenMediaCommand;
	import dm.game.windows.dialogviewer.DialogViewer;
	import dm.game.windows.DmWindowManager;
	import dm.minigames.artgame.ArtGame;
	import dm.minigames.musicgame.MusicGame;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import org.as3commons.lang.ClassUtils;
	import ucc.error.IllegalArgumentException;
	import ucc.sound.SoundManager;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * Function executor
	 * @version $Id: FunctionExecutor.as 214 2013-09-28 18:03:54Z rytis.alekna $
	 */
	public class FunctionExecutor {
		
		private const DM_URL:String = "http://vds000004.hosto.lt/dm/";
		
		/**
		 * Here function names are linked to Executable class definitions
		 */
		private static const functionsToClasses	: Object = {
			confirmFriend 	: AddFriendCommand,
			declineFriend 	: RemoveFriendCommand,
			openMedia	  	: OpenMediaCommand,
			addQuest		: AddQuestCommand,
			completeQuest	: CompleteQuestCommand,
			openShop		: OpenShopCommand,
			refreshInteractions: RefreshInteractionsCommand,
			refreshAltskins	: RefreshAltskinsCommand,
			loot			: LootCommand,
			goHome			: GoHomeCommand,
			updateAvatarSkin: UpdateAvatarSkinCommand,
			askQuestion		: AskQuestionCommand,
			openDialogNode	: OpenDialogNodeCommand,
			goToHomeTown	: GoToHomeTownCommand,
			setTimeout		: SetTimeoutCommand
		};
		
		// static
		{ 
			staticInit();
		}
		
		/**
		 * Static init
		 */
		private static function staticInit () : void {
			// Type.forClass( FunctionExecutor ).methods
		}
		
		/**
		 * (Constructor)
		 * - Returns a new FunctionExecutor instance
		 */
		public function FunctionExecutor() {
		
		}
		
		private function getParamValueByLabel(params:Array, label:String):Object {
			for each (var param:Object in params) {
				if (param.label == label) {
					return param.value;
				}
			}
			return null;
		}
		
		public function executeFunctions(functions:Array, onResult:Function = null):void {
			if (onResult == null) {
				onResult = defaultResultFunction;
			}
			
			if (functions.length == 0) {
				onResult(true);
			}
			
			var functionsExecuted:int = 0;
			
			for each (var func:Object in functions) {
				executeFunction(func, onResponse);
			}
			
			function onResponse(response:Object):void {
				functionsExecuted++;
				
				if (functionsExecuted == functions.length) {
					onResult(true);
				}
			}
		}
		
		/**
		 * Execute function
		 */
		public function executeFunction(func:Object, onResult:Function):void {
			
			/*
			trace( "[dm.game.functions.FunctionExecutor.executeFunction] Type.forInstance( this ).getMethod( func.label ) : " + Type.forInstance( this ).getMethod( func.label ) );
			trace( "[dm.game.functions.FunctionExecutor.executeFunction] func.label : " + func.label );
			
			trace( "[dm.game.functions.FunctionExecutor.executeFunction] ReflectionUtils.getTypeDescription( FunctionExecutor ) : " + ReflectionUtils.getTypeDescription( FunctionExecutor ) );
			*/
			
			if ( functionsToClasses[func.label] ) {
				
				// command may only informaly implement ParameterizedCommand
				if ( ClassUtils.isInformalImplementationOf( functionsToClasses[func.label], ParameterizedCommand ) ) {
					
					var command : * = new functionsToClasses[func.label];
					command.setParams( func.params, onResult );
					command.execute();
					
				}
				
			} else if ( this[func.label] ) {
				if ( ( this[func.label] as Function ).length == 2 ) {
					this[func.label](func.params, onResult);
				} else {
					throw new IllegalArgumentException( "dm.game.functions.FunctionExecutor.executeFunction() : incorrect number of arguments for function [ " + func.label + " ]" );
				}
				
			} else {
				throw new IllegalArgumentException( "dm.game.functions.FunctionExecutor.executeFunction() : trying to execute non existing function [ " + func.label + " ]" );
			}

		}
		
		private final function defaultResultFunction(response:Object):void {
			trace("Function executed");
		}
		
		/* FUNCTION LIST */
		
		private function joinRoom(params:Array, onResult:Function):void {
			var roomLabel:String = String(getParamValueByLabel(params, "label"));
			Main.getInstance().setCurrentRoomName(roomLabel);
			EsManager.instance.joinRoom(roomLabel);
			onResult(true);
		}
		
		private function setVar(params:Array, onResult:Function):void {
			var label:String = String(getParamValueByLabel(params, "label"));
			var value:String = String(getParamValueByLabel(params, "value"));
			
			var amfphp:AMFPHP = new AMFPHP(onResult, null, true);
			amfphp.xcall("dm.Avatar.setVar", MyManager.instance.avatar.id, label, value);
		}
		
		private function modifyVar(params:Array, onResult:Function):void {
			var label:String = String(getParamValueByLabel(params, "label"));
			var value:String = String(getParamValueByLabel(params, "value"));
			
			var amfphp:AMFPHP = new AMFPHP(onResult, null, true);
			amfphp.xcall("dm.Avatar.modifyVar", MyManager.instance.avatar.id, label, value);
		}
		
		private function removeVar(params:Array, onResult:Function):void {
			var label:String = String(getParamValueByLabel(params, "label"));
			
			var amfphp:AMFPHP = new AMFPHP(onResult, null, true);
			amfphp.xcall("dm.Avatar.removeVar", MyManager.instance.avatar.id, label);
		}
		
		private function addItem(params:Array, onResult:Function):void {
			var itemId:int = int(getParamValueByLabel(params, "itemId"));
			
			var amfphp:AMFPHP = new AMFPHP(onResult, null, true);
			amfphp.xcall("dm.Item.addItem", MyManager.instance.avatar.id, itemId);
		}
		
		private function removeItem(params:Array, onResult:Function):void {
			var itemId:int = int(getParamValueByLabel(params, "itemId"));
			
			var amfphp:AMFPHP = new AMFPHP(onResult, null, true);
			amfphp.xcall("dm.Item.removeItem", MyManager.instance.avatar.id, itemId);
		}
		
		private function openDialog(params:Array, onResult:Function):void {
			var dialogId:int = int(getParamValueByLabel(params, "dialogId"));
			WindowsManager.getInstance().createWindow(DialogViewer, null, [dialogId]);
			onResult(true);
		}
		
		private function openURL(params:Array, onResult:Function):void {
			var url:String = String(getParamValueByLabel(params, "url"));
			navigateToURL(new URLRequest(url), "_blank");
			onResult(true);
		}
		
		private function openMusicGame(params:Array, onResult:Function):void {
			var musicGame:MusicGame = new MusicGame();
			DmWindowManager.instance.windowLayer.addChild(musicGame);
			onResult(true);
		}
		
		private function openArtGame(params:Array, onResult:Function):void {
			var artGame:ArtGame = new ArtGame("frontend");
			DmWindowManager.instance.windowLayer.addChild(artGame);
			onResult(true);
		}
		
		private function playAudio(params:Array, onResult:Function):void {
			var audioId:int = int(getParamValueByLabel(params, "audioId"));
			
			var amfphp:AMFPHP = new AMFPHP(onAudioInfo).xcall("dm.Audio.getAudioById", audioId);
			
			onResult(true);
			
			function onAudioInfo(response:Object):void {
				var snd:Sound = new Sound();
				var req:URLRequest = new URLRequest(DM_URL + response.path);
				var context:SoundLoaderContext = new SoundLoaderContext(3000, false);

				snd.load(req, context);
				
				SoundManager.getInstance().startSound(snd, 0, 0, null, true, true);
			}
		}

		
	}

}