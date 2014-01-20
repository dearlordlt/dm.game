package dm.game.functions.commands {
	
	import dm.game.effects.FadingTextEffect;
	import dm.game.functions.BaseExecutable;
	import dm.game.windows.dialogviewer.DialogViewer;
	import dm.game.windows.DmWindowManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ucc.ui.window.WindowsManager;
	import utils.AMFPHP;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class LootCommand extends BaseExecutable {
		
		public override function execute():void {
			trace("FunctionExecutor.loot()");
			var lootId:int = int(getParamValueByLabel("lootId"));
			new AMFPHP(onDialogId).xcall("dm.Loot.getLoot", lootId);
		}
		
		private function onDialogId(response:Object):void {
			var dialogId:int = int(response);
			if (dialogId > 0) {
				WindowsManager.getInstance().createWindow(DialogViewer, null, [dialogId]);
				onResult(true);
			} else {
				trace("Loot will spawn in " + Math.abs(dialogId) + " minutes.");
				var fadingText:FadingTextEffect = new FadingTextEffect("Šiuo metu čia nieko nėra, grįzkite uz " + Math.abs(dialogId) + " minučių.");
				DmWindowManager.instance.windowLayer.addChild(fadingText);
				fadingText.x = fadingText.stage.stageWidth * 0.5 - fadingText.getWidth() * 0.5;
				fadingText.y = fadingText.stage.stageHeight * 0.25;
				fadingText.display();
				
				var timer:Timer = new Timer(1000, 1);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
				function onTimer(e:TimerEvent):void {
					fadingText.hide();
				}
			}
		}
	
	}

}