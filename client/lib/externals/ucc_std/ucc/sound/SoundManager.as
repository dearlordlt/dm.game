package ucc.sound  {
	import ucc.error.IllegalArgumentException;
	import ucc.error.Throwable;
	import ucc.util.ArrayUtil;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
/**
 * Sound manager
 *
 * @version $Id: SoundManager.as 27 2013-05-06 05:42:57Z rytis.alekna $
 */
public class SoundManager {
	
	/** Singleton instance */
	private static var instance 			: SoundManager;
	
	/** Sound start parameters */
	protected var soundStartParams			: Array = [];
	
	/**
	 * Get singleton instance of class
	 * @return 	singleton instance	SoundManager
	 */
	public static function getInstance () : SoundManager {
		return SoundManager.instance ? SoundManager.instance : ( SoundManager.instance = new SoundManager() );
	}
	
	/**
	 * Class constructor
	 */
	public function SoundManager () {
		
	}
	
	/**
	 * Start sound with sound instance
	 * @param	sound
	 * @param	startTimeInMiliseconds
	 * @param	loops
	 * @param	soundTransform
	 * @param	stopOnOtherSound	should sound be stopped if other sound is started playing that requieres to stop other sounds
	 * @param	stopOtherSounds	should playback of this sound stop other "weak" sounds that was started with parameter "stopOnOtherSound" set to true
	 */
	public function startSound ( sound : Sound, startTimeInMiliseconds : uint = 0, loops : int = 0, soundTransform : SoundTransform = null, stopOnOtherSound : Boolean = false, stopOtherSounds : Boolean = false ) : void {
		
		assert( sound, "Sound must not be null!" );
		var soundParams	: SoundParameters = new SoundParameters( sound, null, startTimeInMiliseconds, loops, soundTransform, stopOnOtherSound, stopOtherSounds );
		
		// stop other sounds if they should stop
		if ( soundParams.stopOtherSounds ) {
			this.stopWeakSounds();
		}		
		
		this.soundStartParams.push( soundParams );
		
		this.initSound( soundParams )
	}
	
	/**
	 * Start sound with class
	 * @param	soundClass	reference of to class that subclasses sound
	 * @param	startTimeInMiliseconds
	 * @param	loops
	 * @param	soundTransform
	 */
	public function startSoundWithClass ( soundClass : Class, startTimeInMiliseconds : uint = 0, loops : int = 0, soundTransform : SoundTransform = null, stopOnOtherSound : Boolean = false, stopOtherSounds : Boolean = false ) : void {
		
		var sound : * = new soundClass();
		
		if ( !( sound is Sound ) ) {
			throw new IllegalArgumentException( "Provided class is not sound subclass!" );
		} else {
			this.startSound( sound, startTimeInMiliseconds, loops, soundTransform, stopOnOtherSound, stopOtherSounds );
		}
		
	}
	
	/**
	 * Init sound
	 * @param	sound
	 */
	protected function initSound ( soundParams : SoundParameters ) : void {
		
		var soundChannel		: SoundChannel;
		
		soundChannel = soundParams.sound.play( soundParams.startTime, ( ( soundParams.loopsLeft == -1 ) ? 0 : soundParams.loopsLeft ), soundParams.soundTransform );
		soundChannel.addEventListener( Event.SOUND_COMPLETE, this.onSoundComplete );
		soundParams.soundChannel = soundChannel;
		
	}
	
	/**
	 * On sound complete
	 */
	public function onSoundComplete ( event : Event ) : void {
		
		var soundChannel		: SoundChannel = event.target as SoundChannel;
		var sound				: Sound;
		
		var soundParams : SoundParameters = ArrayUtil.getElementByPropertyValue( this.soundStartParams, "soundChannel", soundChannel );
		
		soundChannel.removeEventListener( Event.SOUND_COMPLETE, this.onSoundComplete );
		soundChannel = null;
		
		if ( soundParams.loopsLeft > 0 ) {
			soundParams.loopsLeft--;
		} else if ( soundParams.loopsLeft == 0 ) {
			
			ArrayUtil.removeElementByReference( this.soundStartParams, soundParams );
			return;
		}
		
		this.initSound( soundParams );
		
	}
	
	/**
	 * Stop sound by instance or class
	 * @param	sound
	 */
	public function stopSound ( sound : Sound ) : void {
		
		assert( sound, "Sound instance must be specified!" );
		
		var soundParams : Array = ArrayUtil.getElementsByPropertyValue( this.soundStartParams, "sound", sound );
		
		for each( var soundParam : SoundParameters in soundParams ) {
			soundParam.soundChannel.stop();
			soundParam.clean();
			ArrayUtil.removeElementByReference( this.soundStartParams, soundParam );
		}
		
	}	
	
	/**
	 * Stop sound by class
	 * @param	soundClass
	 */
	public function stopSoundByClass ( soundClass : Class ) : void {
		
		var itemsToRemove : Array = [];
		
		for each( var soundParam : SoundParameters in this.soundStartParams ) {
			if ( soundParam.sound is soundClass ) {
				soundParam.soundChannel.stop();
				soundParam.clean();
				itemsToRemove.push( soundParam );
			}
		}
		
		ArrayUtil.removeElements( this.soundStartParams, itemsToRemove );
		
	}
	
	/**
	 * Stop all sounds
	 */
	public function stopAllSounds () : void {
		
		var itemsToRemove : Array = [];
		
		for each( var soundParam : SoundParameters in this.soundStartParams ) {
			soundParam.soundChannel.stop();
			soundParam.clean();
			itemsToRemove.push( soundParam );
		}
		
		ArrayUtil.removeElements( this.soundStartParams, itemsToRemove );
		
	}
	
	/**
	 * Stop weak sounds (that should be stopped on other sounds)
	 */
	public function stopWeakSounds () : void {
		var itemsToRemove : Array = [];
		
		for each( var soundParam : SoundParameters in this.soundStartParams ) {
			if ( soundParam.stopOnOtherSound ) {
				soundParam.soundChannel.stop();
				soundParam.clean();
				itemsToRemove.push( soundParam );
			}
		}
		
		ArrayUtil.removeElements( this.soundStartParams, itemsToRemove );
		
	}
	
}
	
}
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import ucc.util.StringUtil;


/**
 * Sound parameters
 */
class SoundParameters {
	
	/** stopOnOtherSound */
	public var stopOnOtherSound : Boolean;
		
	/** stopOtherSounds */
	public var stopOtherSounds : Boolean;
	
	public var soundChannel 		: SoundChannel;
	public var loopsLeft 			: int;
	public var startTime 			: int;
	public var soundTransform 		: SoundTransform;
	public var sound 				: Sound;
	
	public var uuid					: String;
	
	/**
	 * Class constructor
	 */
	public function SoundParameters ( sound : Sound = null, soundChannel : SoundChannel = null, startTime : int = 0, loopsLeft : int = 0,  soundTransform : SoundTransform = null, stopOnOtherSound : Boolean = false, stopOtherSounds : Boolean = false ) {
		this.stopOnOtherSound = stopOnOtherSound;
		this.stopOtherSounds = stopOtherSounds;
		this.soundTransform = soundTransform;
		this.startTime = startTime;
		this.loopsLeft = loopsLeft;
		this.soundChannel = soundChannel;
		this.sound = sound;
		this.uuid = StringUtil.random();
	}
	
	/**
	 * Clean up instance
	 */
	public function clean () : void {
		this.soundTransform = null;
		this.startTime = 0;
		this.loopsLeft = 0;
		this.soundChannel = null;
		this.sound = null;
	}
	
}