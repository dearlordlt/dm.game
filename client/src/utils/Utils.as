package utils {
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author
	 */
	public class Utils {
		
		public function Utils() {
		
		}
		
		public static function compareArrays(arr1:Array, arr2:Array):Boolean {
			if (arr1.length == arr2.length) {
				for each (var item:Object in arr1)
					if (arr2.indexOf(item) == -1)
					 return false;
				return true;
			} else
				return false;
		}
		
		public static function copyMeshes(from:Pivot3D, to:Pivot3D):void {
			trace("Utils.copyMeshes(): " + from.children);
			for each (var part:Pivot3D in from.children)
				if (part is Mesh3D) {
					trace("Mesh found");
					to.addChild(part.clone());
				}
		}
		
		public static function clearNonMesh(skin:Pivot3D):void {
			for each (var child:Pivot3D in skin.children.concat()) {
				if (child.children.length == 0) {
					if (!(child is Mesh3D))
						skin.removeChild(child);
				} else
					clearNonMesh(child);
			}
		}
		
		public static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		public static function rayPlane(pNormal:Vector3D, pCenter:Vector3D, rFrom:Vector3D, rDir:Vector3D):Vector3D {
			var dist:Number = -(pNormal.dotProduct(rFrom) - pNormal.dotProduct(pCenter)) / pNormal.dotProduct(rDir);
			return new Vector3D(rFrom.x + rDir.x * dist, rFrom.y + rDir.y * dist, rFrom.z + rDir.z * dist);
		}
		
		public static function clearDictionary(dictionary:Dictionary):void {
			var idVec:Vector.<Object> = new Vector.<Object>();
			for (var obj:Object in dictionary)
				idVec.push(obj);
			
			var vLen:int = idVec.length;
			for (var i:int = 0; i < vLen; i++) {
				delete dictionary[idVec[i]];
				idVec[i] = null;
			}
		}
	}

}