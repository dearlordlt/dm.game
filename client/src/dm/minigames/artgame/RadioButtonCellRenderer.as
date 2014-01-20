package dm.minigames.artgame
{
	/**
	 * ...
	 * @author Darius Dauskurdis dariusdxd@gmail.com
	 */
	
	 //Ši klasė skirta sugeneruoti radiobuttons datagrid komponentui
	 //Taip pat galima pasidaryti ir kitais (checkbox, images ir pan...)
	 //Butinai reikia atkreipti demesi i kintamuju pavadinimus, nes tik tikslus pavadinimai tinka komponentams
	import fl.controls.RadioButton; 
	import flash.events.MouseEvent;
	import fl.controls.listClasses.ListData;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.RadioButtonGroup; 
	 
	public class RadioButtonCellRenderer extends RadioButton implements ICellRenderer 
	{
		
		protected var _data:Object;
		protected var _listData:ListData;
		//protected var _groupData:RadioButtonGroup;

		public function RadioButtonCellRenderer() 
		{
			super();
			label = "";
			//group = _groupData;
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onClick(e:MouseEvent):void{
			_selected = ! _selected;
			_data.col3 = _selected;
		}

		public function get data():Object{
			return _data;
		}

		public function set data(value:Object):void {
			//trace(value);
			_data = value;
			_selected = _data.col3;
			name = "rrr";
			//trace(_data.col3[1]);
			//group = "aaa"; 
			
			
			//var main_parent:*; 
			//main_parent = this.parent.parent.parent.parent.parent.parent;
			
			
			
			//group = main_parent.r_group;
			
			
			
			//trace(main_parent.r_group)
			
			
			//this.group = _data.Available[1];
		}

		public function get listData():ListData{
			return _listData;
		}

		public function set listData(value:ListData):void{
			_listData = value;
			
		}

		/*override public function get group():RadioButtonGroup{
			return group;
		}*/

		

		override public function get selected():Boolean{
			return _selected;
		}

		override public function set selected(value:Boolean):void{
		}
	}

}