package components 
{
	import flare.core.*;
	import flare.modifiers.*;
	import flash.events.*;
	import flash.geom.*;
 
	/**
	 * @author Ariel Nehmad
	 */
	public class BoneController implements IComponent 
	{
		private var _skin:SkinModifier;
		private var _mesh:Mesh3D;
		private var _bone:Pivot3D;
		private var _target:Pivot3D;
		private var _transform:Matrix3D;
 
		public function BoneController( skinnedMesh:Mesh3D, boneName:String ) 
		{
			_mesh = skinnedMesh;
			_skin = skinnedMesh.modifier as SkinModifier;
 
			if ( _skin )
			{
				_bone = _skin.root.getChildByName( boneName );
 
				if ( _bone ) return;
			}
 
			throw skinnedMesh.name + " isn't a skinned mesh!";			
		}
 
		/* INTERFACE flare.core.IComponent */
 
		public function added( target:Pivot3D ):Boolean 
		{
			_target = target;
			
			// this forces to the target to be drawn after the skinned mesh is transformed.
			_target.setLayer( _mesh.layer + 1 );
			
			_transform = target.transform.clone();
			
			// we listening to the exit draw, because we need the bones already transformed.
			_mesh.addEventListener( Pivot3D.EXIT_DRAW_EVENT, exitDrawEvent, false, 0, true );
			
			return true;
		}
		
		private function exitDrawEvent(e:Event):void 
		{
			// get the bone matrix transform. ( bone transform + mesh transform )
			_target.transform.copyFrom( _transform );
			_target.transform.append( _bone.world ); 
			_target.transform.append( _mesh.world );
			_target.updateTransforms(true);
		}
 
		public function removed():Boolean 
		{
			_mesh.removeEventListener( Pivot3D.EXIT_DRAW_EVENT, exitDrawEvent );
			_target = null;
			_transform = null;
			
			return true;
		}
	}
}