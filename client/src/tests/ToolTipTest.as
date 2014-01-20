package tests 
{
	import com.bit101.components.PushButton;
	import dm.game.windows.dialogviewer.DialogViewer;
	import dm.game.windows.DmWindow;
	import dm.game.windows.inventory.Inventory;
	import dm.game.windows.Tooltip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author zenia
	 */
	public class ToolTipTest extends Sprite 
	{
		
		public function ToolTipTest() 
		{
			//var window:Inventory = new Inventory(this);
			var window:DialogViewer = new DialogViewer(this, 224);
			window.x = 200;
			window.y = 200;
			//var btn:PushButton = new PushButton(this, 100, 100, "WWW");
			//var btn_tt:Tooltip = new Tooltip(btn, "False");
		}
		
	}

}