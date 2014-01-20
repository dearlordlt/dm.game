package dm.builder.interfaces.tools.custombuildingeditor {
	import flare.core.Pivot3D;
	import flare.system.Library3D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CustomBuildingFactory {
		
		public static function build(library:Library3D, type:String, floorNum:int):Pivot3D {
			
			var building:Pivot3D = new Pivot3D;
			
			var floor1:Pivot3D = Pivot3D(library.getItem(type + "_floor1")).clone();
			floor1.name = type + "_floor1";
			building.addChild(floor1);
			
			var floorHeight:Number = 0;
			
			var i:int;
			var floorN:Pivot3D;
			
			switch (type) {
				case "aparth_a": 
					floorHeight = 282;
					for (i = 1; i < floorNum; i++) {
						floorN = Pivot3D(library.getItem(type + "_floorN")).clone();
						floorN.name = type + "_floorN";
						building.addChild(floorN);
						floorN.y += floorHeight * i;
					}
					break;
				case "aparth_bc": 
					floorHeight = 300;
					floor1.y = 0;
					for (i = 0; i < floorNum - 1; i++) {						
						floorN = Pivot3D(library.getItem(type + "_floorN")).clone();
						floorN.name = type + "_floorN";
						building.addChild(floorN);
						floorN.y = 400 + floorHeight * i;
					}
					break;
			}
			
			try {
				var roof:Pivot3D = Pivot3D(library.getItem(type + "_roof")).clone();
				roof.name = type + "_roof";
				building.addChild(roof);
				roof.y = floorNum * floorHeight;
			} catch (e:Error) {
				//trace("BuildingFactory: No roof for this building type");
			}
			
			return building;
		}
	}

}